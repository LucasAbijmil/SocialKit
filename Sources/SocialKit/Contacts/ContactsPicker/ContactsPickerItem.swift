//
//  File.swift
//  ContactsKit
//
//  Created by Michel-Andre Chirita on 12/10/2024.
//

import Foundation

public struct ContactsPickerItem<Contact: Identifiable>: Identifiable {

    public var id: Contact.ID { contact.id }
    let contact: Contact
    let displayName: String
    let secondaryDisplayName: String
    let photo: Photo
    let phoneNumbers: [String]
    var selectedPhoneNumber: String?

    static func loadingItem(contact: Contact) -> ContactsPickerItem { ContactsPickerItem(contact: contact, displayName: "Loading...", secondaryDisplayName: "", photo: .none, phoneNumbers: [], selectedPhoneNumber: nil) }

    public init(contact: Contact, displayName: String, secondaryDisplayName: String, photo: Photo, phoneNumbers: [String], selectedPhoneNumber: String? = nil, isSelected: Bool = false) {
        self.contact = contact
        self.displayName = displayName
        self.secondaryDisplayName = secondaryDisplayName
        self.photo = photo
        self.phoneNumbers = phoneNumbers
        self.selectedPhoneNumber = selectedPhoneNumber
    }
}

extension ContactsPickerItem where Contact == LocalContact {
    init(from localContact: LocalContact) {
        let photo: Photo
        if let localImageData = localContact.localImageData {
            photo = .data(localImageData)
        } else {
            photo = .none
        }
        self.init(contact: localContact,
                  displayName: localContact.displayName ?? "",
                  secondaryDisplayName: localContact.secondaryDisplayName ?? "",
                  photo: photo,
                  phoneNumbers: localContact.phoneNumbers)
    }
}

extension ContactsPickerItem {
    static func sort(lhs: Self, rhs: Self, sorting: ContactSorting) -> Bool {
        switch sorting {
        case .name:
            lhs.displayName < rhs.displayName
        case .withPhoto:
            (!lhs.photo.isEmpty && rhs.photo.isEmpty) ||
            (!lhs.photo.isEmpty && !rhs.photo.isEmpty && lhs.displayName < rhs.displayName)
        }
    }
}
