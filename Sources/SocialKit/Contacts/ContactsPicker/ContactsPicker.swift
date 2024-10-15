//
//  ContactsPicker.swift
//  ContactsKit
//
//  Created by Michel-André Chirita on 08/10/2024.
//

import SwiftUI

public struct ContactsPicker<CustomContact: Identifiable, PermissionView: View>: View {

    public enum SearchKind {
        case none
        case inNavBar(alwaysDisplay: Bool)
        case onTopOfList
    }

    public enum ContactActionResult {
        case messageSent
        case contactSelected
        case contactUnselected
    }

    struct SendMessageSetup {
        var contact: ContactsPickerContact<CustomContact>? = nil
        var bodyMessage: String = ""
        var showSelectPhoneNumber = false
        var selectedPhoneNumber: String? = nil
        var showMessageView = false
    }

    @StateObject private var viewModel: ContactsPickerViewModel<CustomContact>
    @Binding var selectedContacts: [ContactsPickerContact<CustomContact>]
    @Binding private var hasGrantedPermission: Bool?
    @State private var searchKind: SearchKind = .none
    @State private var showAllContacts: Bool = false
    @State private var sendMessageSetup: SendMessageSetup = SendMessageSetup()
    private var colors: ContactsPickerColors
    private var wordings: ContactsPickerWordings
    private var permissionView: (() -> PermissionView)?
    private let contactTappedAction: (ContactsPickerContactResult<CustomContact>, ContactActionResult) -> Void

    public init(searchKind: SearchKind = .inNavBar(alwaysDisplay: false),
                sections: [ContactsPickerSection<CustomContact>],
                selectedContacts: Binding<[ContactsPickerContact<CustomContact>]> = .constant([]),
                hasGrantedPermission: Binding<Bool?> = .constant(true),
                permissionView: (() -> PermissionView)? = nil,
                cacheService: CacheService? = nil,
                uploadContactsService: UploadContactsService? = nil,
                colors: ContactsPickerColors = ContactsPickerColors(),
                wordings: ContactsPickerWordings = ContactsPickerWordings(),
                contactTappedAction: @escaping (ContactsPickerContactResult<CustomContact>, ContactActionResult) -> Void) {
        self._viewModel = StateObject(wrappedValue: ContactsPickerViewModel(sections: sections, cacheService: cacheService, uploadContactsService: uploadContactsService))
        self.searchKind = searchKind
        self._selectedContacts = selectedContacts
        self._hasGrantedPermission = hasGrantedPermission
        self.permissionView = permissionView
        self.colors = colors
        self.wordings = wordings
        self.contactTappedAction = contactTappedAction
    }

    public var body: some View {
        Group {
            switch searchKind {
            case .inNavBar(alwaysDisplay: let alwaysDisplay):
                listView
                    .searchable(text: $viewModel.searchString,
                                placement: .navigationBarDrawer(displayMode: alwaysDisplay ? .always : .automatic))
            default:
                listView
            }
        }
        .navigationTitle(wordings.navBarTitle)
        .environmentObject(colors)
        .environmentObject(wordings)
        .confirmationDialog(wordings.selectPhoneNumber, isPresented: $sendMessageSetup.showSelectPhoneNumber, titleVisibility: .visible) {
            if let contactToInvite = sendMessageSetup.contact {
                ForEach(contactToInvite.phoneNumbers, id: \.self) { phoneNumber in
                    Button(phoneNumber) {
                        self.sendMessageSetup.selectedPhoneNumber = phoneNumber
                        self.sendMessageSetup.showMessageView = true
                    }
                }
            }
        }
        .sheet(isPresented: $sendMessageSetup.showMessageView) {
            if let phoneNumber = sendMessageSetup.selectedPhoneNumber,
               let contact = sendMessageSetup.contact,
                MessageView.canSendMessage {
                MessageView(recipient: phoneNumber, body: sendMessageSetup.bodyMessage) { didSent in
                    self.sendMessageSetup.contact = nil
                    self.sendMessageSetup.selectedPhoneNumber = nil
                    if didSent { self.contactTappedAction(contact.contactResult, .messageSent) }
                }
                .ignoresSafeArea()
            }
        }
    }
    
    private var listView: some View {
        List {
            if case .onTopOfList = searchKind {
                SearchField(searchString: $viewModel.searchString)
            }
            
            switch viewModel.state {
            case .loading:
                loadingSectionView

            case .displayed:
                ForEach(viewModel.sections) { section in
                    sectionView(for: section)
                }

            case .search(let isSearching):
                if isSearching {
                    loadingSectionView
                } else {
                    searchResults
                }

            case .error(let errorMessage):
                Text(errorMessage) // TODO: to finish...
                    .foregroundStyle(.red)
            }

            Spacer(minLength: 60)
                .listRowBackground(Color.clear)
        }
        .onAppear {
            viewModel.fetchLocalCotacts(sorting: .withPhoto)
        }
        .onChange(of: hasGrantedPermission) { value in
            guard value == true else { return }
            viewModel.fetchLocalCotacts(sorting: .withPhoto)
        }
    }

    @ViewBuilder
    private func sectionView(for section: ContactsPickerSection<CustomContact>) -> some View {
            switch section {
            case .customContacts(let title, let items, _, let actionKind):
                Section(title) {
                    ForEach(items) { item in
                        ContactLineView(photos: [item.photo],
                                        title: item.displayName,
                                        subtitle: item.secondaryDisplayName,
                                        actionKind: actionKind,
                                        isSelected: selectedContacts.contains(.custom(item))) {
                            tapAction(item: .custom(item), actionKind: actionKind)
                        }
                    }
                }
            case .localContacts(let title, let items, let actionKind, _, let displayOnlyFirst):
                Section(title) {
                    if hasGrantedPermission == true,
                        let localContacts = items ?? viewModel.localContacts {
                        let featuredContacts = displayOnlyFirst != nil ? Array(localContacts.prefix(displayOnlyFirst!)) : localContacts

                        localContactsView(contacts: featuredContacts, actionKind: actionKind)

                        if let displayOnlyFirst, localContacts.count > displayOnlyFirst {
                            if !showAllContacts {
                                moreContactsButton
                            }
                            else {
                                let moreContacts = Array(localContacts.suffix(from: displayOnlyFirst))
                                localContactsView(contacts: moreContacts, actionKind: actionKind)
                            }
                        }
                    } else if let permissionView {
                        permissionView()
                    } else {
                        EmptyView() // TODO: cas où aucun contact dans le tel ou permission donnée partiellement avec aucun contact sélectionné
                    }
                }
            }
    }

    @ViewBuilder
    private func localContactsView(contacts: [ContactsPickerItem<LocalContact>], actionKind: ContactActionKind) -> some View {
        ForEach(contacts) { item in
            ContactLineView(photos: [item.photo],
                            title: item.displayName,
                            subtitle: item.secondaryDisplayName,
                            actionKind: actionKind,
                            isSelected: selectedContacts.contains(.local(item))) {
                tapAction(item: .local(item), actionKind: actionKind)
            }
        }
    }

    @ViewBuilder
    private var moreContactsButton: some View {
        ZStack(alignment: .center) {
            Button {
                showAllContacts = true
            } label: {
                Text(wordings.showAllContacts)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(colors.primaryBackground)
                    .padding(5)
                    .padding(.horizontal, 5)
                    .background {
                        Capsule()
                            .fill(colors.seconaryAccent)
                    }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical)
    }

    @ViewBuilder
    private var loadingSectionView: some View {
        SwiftUI.Section(wordings.loading) {
            ForEach(0..<10) { _ in
                ContactLineView(photos: [.none],
                                title: "Lorem Ipsum",
                                subtitle: "00 00 00 00 00",
                                actionKind: .none,
                                isSelected: false)
                .redacted(reason: .placeholder)
            }
        }
    }

    @ViewBuilder
    private var searchResults: some View {
        if let searchDatasource = viewModel.searchDatasource, !searchDatasource.isEmpty {
            ForEach(searchDatasource) { section in
                sectionView(for: section)
            }
        } else {
            if #available(iOS 17.0, *) {
                ContentUnavailableView.search(text: viewModel.searchString)
            } else {
                VStack(alignment: .center) {
                    Spacer()
                    Text("No results for \"\(viewModel.searchString)\".")
                    Spacer()
                }
            }
        }
    }

    private func tapAction(item: ContactsPickerContact<CustomContact>, actionKind: ContactActionKind) {
        switch actionKind {
        case .select:
            let isSelected = selectedContacts.contains(item)
            contactTappedAction(item.contactResult, isSelected ? .contactUnselected : .contactSelected)
            if  isSelected {
                selectedContacts.remove(item)
            } else {
                selectedContacts.append(item)
            }

        case .tap:
            contactTappedAction(item.contactResult, .contactSelected)

        case .sendMessage(let title, let body):
            self.sendMessageSetup.contact = item
            self.sendMessageSetup.bodyMessage = body
            if item.phoneNumbers.count > 1 {
                self.sendMessageSetup.showSelectPhoneNumber = true
            } else if item.phoneNumbers.count == 1 {
                self.sendMessageSetup.selectedPhoneNumber = item.phoneNumbers.first
                self.sendMessageSetup.showMessageView = true
            }

        case .none:
            break
        }
    }
}

#Preview {
    ContactsPicker<MockContact, EmptyView>(searchKind: .onTopOfList,
                                           sections: [.localContacts(title: "My contacts", actionKind: .none)]) { contact, actionResult in
        switch contact {
        case .local(let local): print("LocalContact tapped")
        case .custom(let custom): print("MockContact tapped")
        }
    }
}

private struct MockContact: Identifiable {
    let id: UUID = UUID()
}
