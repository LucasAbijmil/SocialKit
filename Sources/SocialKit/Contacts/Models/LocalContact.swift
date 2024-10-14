//
//  ContactsKit.swift
//  ContactsKit
//
//  Created by Michel-André Chirita on 03/10/2024.
//

import Foundation

// MARK: - Local contact (from address book)

public struct LocalContact: Codable, Identifiable {
    
    public typealias ID = String

    public let id: ID
    public let firstName: String?
    public let lastName: String?
    public let phoneNumbers: [String]
    public var selectedPhoneNumber: String?
    public var localImageData: Data?

    public var displayName: String? {
        let nameArray = [firstName, lastName].compactMap {$0}
        return nameArray.count > 0 ?  nameArray.joined(separator: " ") : nil
    }
    var reversedDisplayName: String? {
        let nameArray = [lastName, firstName].compactMap {$0}
        return nameArray.count > 0 ?  nameArray.joined(separator: " ") : nil
    }
    var secondaryDisplayName: String? {
        return selectedPhoneNumber ?? phoneNumbers.first
    }
}

extension LocalContact: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(firstName)
        hasher.combine(lastName)
        hasher.combine(phoneNumbers)
    }
}

extension LocalContact: Comparable {
    public static func < (lhs: LocalContact, rhs: LocalContact) -> Bool {
        if lhs.displayName?.isEmpty == true || lhs.displayName == nil {
            false
        } else if rhs.displayName?.isEmpty == true || rhs.displayName == nil {
            true
        } else {
            if lhs.firstName == rhs.firstName {
                (lhs.lastName ?? "") < (rhs.lastName ?? "")
            }
            else {
                (lhs.firstName ?? "") < (rhs.firstName ?? "")
            }
        }
    }
}

extension LocalContact: Equatable {
    public static func == (lhs: LocalContact, rhs: LocalContact) -> Bool {
        lhs.id == rhs.id &&
        lhs.firstName == rhs.firstName &&
        lhs.lastName == rhs.lastName &&
        lhs.phoneNumbers == rhs.phoneNumbers
    }
}

extension LocalContact {
    static var mock: LocalContact {
        LocalContact(id: UUID().uuidString, 
                     firstName: "Mickael",
                     lastName: "Dupont",
                     phoneNumbers: ["0101010101", "020202020020", "033030303030"])
    }
}
