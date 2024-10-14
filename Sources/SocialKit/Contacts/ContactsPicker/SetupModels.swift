//
//  File.swift
//  ContactsKit
//
//  Created by Michel-Andre Chirita on 13/10/2024.
//

import SwiftUI

public enum ContactsPickerContact<CustomContact: Identifiable>: Identifiable
where CustomContact.ID: Hashable {

    case custom(ContactsPickerItem<CustomContact>)
    case local(ContactsPickerItem<LocalContact>)

    public var id: String {
        switch self {
        case .custom(let item): String(item.id.hashValue)
        case .local(let item): item.id
        }
    }

    var displayName: String {
        switch self {
        case .custom(let item): item.displayName
        case .local(let item): item.displayName
        }
    }

    var phoneNumbers: [String] {
        switch self {
        case .custom(let item): item.phoneNumbers
        case .local(let item): item.phoneNumbers
        }
    }

    var contactResult: ContactsPickerContactResult<CustomContact> {
        switch self {
        case .custom(let item): .custom(item.contact)
        case .local(let item): .local(item.contact)
        }
    }
}
extension ContactsPickerContact: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case (.custom(let l), .custom(let r)): return l.id == r.id
        case (.local(let l), .local(let r)): return l.id == r.id
        default: return false
        }
    }

    public static func ==<T: Identifiable & Hashable> (lhs: Self, rhs: T) -> Bool {
        lhs.id == String(rhs.id.hashValue)
    }

    public static func ==<T: Identifiable & Hashable> (lhs: T, rhs: Self) -> Bool {
        String(lhs.id.hashValue) == rhs.id
    }
}

public enum ContactsPickerContactResult<CustomContact> {
    case custom(CustomContact)
    case local(LocalContact)
}

public enum ContactActionKind {
    case none
    case select(title: String = "")
    case tap(title: String = "")
    case sendMessage(title: String = "", body: String)

    var title: String {
        switch self {
        case .none: ""
        case .select(let title): title
        case .tap(let title): title
        case .sendMessage(let title, _): title
        }
    }
}

public final class ContactsPickerWordings: ObservableObject {
    let navBarTitle: String
    let selectPhoneNumber: String
    let showAllContacts: String
    let searchBarPlaceholder: String
    let cancel: String
    let loading: String
    public init(navBarTitle: String = "",
                selectPhoneNumber: String = "Select a phone number",
                showAllContacts: String = "Show all contacts",
                searchBarPlaceholder: String = "Search...",
                cancel: String = "Cancel",
                loading: String = "Loading...") {
        self.navBarTitle = navBarTitle
        self.selectPhoneNumber = selectPhoneNumber
        self.showAllContacts = showAllContacts
        self.searchBarPlaceholder = searchBarPlaceholder
        self.cancel = cancel
        self.loading = loading
    }
}

public final class ContactsPickerColors: ObservableObject {
    let primaryForeground: Color
    let secondaryForeground: Color
    let primaryBackground: Color
    let secondaryBackground: Color
    let primaryAccent: Color
    let seconaryAccent: Color
    public init(primaryForeground: Color? = nil,
                secondaryForeground: Color? = nil,
                primaryBackground: Color? = nil,
                secondaryBackground: Color? = nil,
                primaryAccent: Color? = nil,
                seconaryAccent: Color? = nil) {
        self.primaryForeground = primaryForeground ?? Color("primaryForeground", bundle: .module)
        self.secondaryForeground = secondaryForeground ?? Color("secondaryForeground", bundle: .module)
        self.primaryBackground = primaryBackground ?? Color("primaryBackground", bundle: .module)
        self.secondaryBackground = secondaryBackground ?? Color("secondaryBackground", bundle: .module)
        self.primaryAccent = primaryAccent ?? Color("primaryAccent", bundle: .module)
        self.seconaryAccent = seconaryAccent ?? Color("secondaryAccent", bundle: .module)
    }
}
