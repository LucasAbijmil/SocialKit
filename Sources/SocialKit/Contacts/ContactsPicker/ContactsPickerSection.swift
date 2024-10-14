//
//  File.swift
//  ContactsKit
//
//  Created by Michel-Andre Chirita on 12/10/2024.
//

import Foundation

public enum ContactsPickerSection<CustomContact: Identifiable>: Identifiable {

    case customContacts(title: String,
                        items: [ContactsPickerItem<CustomContact>],
                        enrichStyle: EnrichStyle = .both,
                        actionKind: ContactActionKind)

    case localContacts(title: String,
                       items: [ContactsPickerItem<LocalContact>]? = nil,
                       actionKind: ContactActionKind,
                       sortedBy: ContactSorting = .withPhoto,
                       displayOnlyFirst: Int? = 10)

    public var id: String {
        switch self {
        case .customContacts(let title, _, _, _): "custom" + title
        case .localContacts: "localContacts"
        }
    }

    public var isLocalContacts: Bool {
        switch self {
        case .customContacts: false
        case .localContacts: true
        }
    }

    public var sortedBy: ContactSorting? {
        switch self {
        case .customContacts: nil
        case .localContacts(_, _, _, sortedBy: let sorting, _): sorting
        }
    }

    public enum EnrichStyle {
        case none
        case localPhoto
        case localName
        case both
    }
}

public enum ContactSorting: String, CaseIterable {
    case name
    case withPhoto
}
