//
//  ContactsPickerItemModel.swift
//  ContactsKit
//
//  Created by Michel-Andre Chirita on 12/10/2024.
//

import SwiftUI
import Combine

final class ContactsPickerViewModel<CustomContact: Identifiable>: ObservableObject {

    enum ViewState {
        case loading
        case displayed
        case search(isSearching: Bool)
        case error(String)
    }

    @Published var sections: [ContactsPickerSection<CustomContact>] = []
    @Published var localContacts: [ContactsPickerItem<LocalContact>]? = nil
    @Published var state: ViewState = .loading
    @Published var searchString: String = ""
    @Published var searchDatasource: [ContactsPickerSection<CustomContact>]? = nil
    private let localContactsService: LocalContactsService
    private var cancellables: Set<AnyCancellable> = []
    private var searchTask: Task<(), Error>? = nil

    init(sections: [ContactsPickerSection<CustomContact>], cacheService: CacheService?, uploadContactsService: UploadContactsService?) {
        self.sections = sections
        self.localContactsService = LocalContactsService(cacheService: cacheService, uploadContactsService: uploadContactsService)

        $searchString
            .dropFirst()
            .removeDuplicates()
            .receive(on: RunLoop.main)
            .sink { [weak self] searchString in
                guard let self else { return }
                self.searchTask?.cancel()
                if searchString.isEmpty {
                    self.searchDatasource = nil
                    self.state = .displayed
                } else {
                    self.state = .search(isSearching: true)
                    self.searchTask = Task {
                        await self.search(with: searchString)
                    }
                }
            }
            .store(in: &cancellables)
    }


    // MARK: - Fetch

    func fetchLocalCotacts(sorting: ContactSorting) {
        guard let localContactsSection = sections.first(where: \.isLocalContacts), let sorting = localContactsSection.sortedBy
        else {
            self.state = .displayed
            return
        }

        Task {
            let localContacts = try? await localContactsService.fetchAllLocalContacts()
                .map { ContactsPickerItem(from: $0) }
                .sorted(by: { ContactsPickerItem.sort(lhs: $0, rhs: $1, sorting: sorting) })

            if let localContacts {
                enrichCustomContacts(with: localContacts)
            }

            await MainActor.run {
                self.localContacts = localContacts
                self.state = .displayed
            }
        }
    }

    private func enrichCustomContacts(with localContacts: [ContactsPickerItem<LocalContact>]) {
        var sections: [ContactsPickerSection<CustomContact>] = self.sections.map { section in
            switch section {
            case .customContacts(let title, let items, let enrichStyle, let actionKind):
                if enrichStyle != .none {
                    let enrichedItems = enrich(items: items, with: localContacts, style: enrichStyle)
                    return .customContacts(title: title, items: enrichedItems, enrichStyle: .none, actionKind: actionKind)
                } else {
                    return section
                }
            case .localContacts(let title, let items, let actionKind, let sortedBy, let displayOnlyFirst):
                return section
            }
        }

        Task { @MainActor in
            self.sections = sections
        }
    }

    private func enrich(items: [ContactsPickerItem<CustomContact>], with localContacts: [ContactsPickerItem<LocalContact>], style: ContactsPickerSection<CustomContact>.EnrichStyle) -> [ContactsPickerItem<CustomContact>] {
        let items = items.map { item in
            if let matchingLocal = localContacts.first { localItem in
                localItem.displayName.lowercased() == item.displayName.lowercased() ||
                localItem.phoneNumbers.intersects(with: item.phoneNumbers)
            } {
                let phoneNumbers = Array(Set(matchingLocal.phoneNumbers + item.phoneNumbers))
                let photo: Photo = !matchingLocal.photo.isEmpty ? matchingLocal.photo : item.photo

                switch style {
                case .none:
                    return item

                case .localPhoto:
                    return ContactsPickerItem(contact: item.contact, displayName: item.displayName, secondaryDisplayName: item.secondaryDisplayName, photo: photo, phoneNumbers: phoneNumbers)

                case .localName:
                    return ContactsPickerItem(contact: item.contact, displayName: matchingLocal.displayName, secondaryDisplayName: matchingLocal.secondaryDisplayName, photo: item.photo, phoneNumbers: phoneNumbers)

                case .both:
                    return ContactsPickerItem(contact: item.contact, displayName: matchingLocal.displayName, secondaryDisplayName: matchingLocal.secondaryDisplayName, photo: photo, phoneNumbers: phoneNumbers)
                }
            } else {
                return item
            }
        }
        return items
    }

    // MARK: - Search

    private func search(with query: String) async {
        do {
            var results: [ContactsPickerSection<CustomContact>] = []
            for section in sections {
                switch section {
                case .customContacts(let title, let items, _, let actionKind):
                    let filteredItems = items.filter { $0.displayName.contains(query) || $0.secondaryDisplayName.contains(query) }
                    guard !filteredItems.isEmpty else { break }
                    results.append(.customContacts(title: title, items: filteredItems, actionKind: actionKind))

                case .localContacts(let title, let items, let actionKind, let sorting, _):
                    let filteredItems = try await localContactsService.search(query: query)
                        .map { ContactsPickerItem(from: $0) }
                        .sorted(by: { ContactsPickerItem.sort(lhs: $0, rhs: $1, sorting: sorting) })
                    guard !filteredItems.isEmpty else { break }
                    results.append(.localContacts(title: title, items: filteredItems, actionKind: actionKind))
                }
            }

            await MainActor.run {
                self.searchDatasource = results
                self.state = .search(isSearching: false)
            }
        } catch {
            await MainActor.run {
                self.state = .search(isSearching: false)
            }
        }
    }
}
