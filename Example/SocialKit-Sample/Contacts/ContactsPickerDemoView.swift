//
//  Cont.swift
//  ContactsKit-Sample
//
//  Created by Michel-Andre Chirita on 12/10/2024.
//

import SwiftUI
import SocialKit
import PermissionsKit

struct ContactsPickerDemoView: View {

    private let permissionsService = PermissionsService()
    @State private var hasGrantedContactsPermission: Bool? = nil

    var body: some View {
        Group {
            if hasGrantedContactsPermission == true {
                contactsPickerView
            } else {
                permissionView
            }
        }
        .onAppear {
            hasGrantedContactsPermission = permissionsService.hasGrantedContactsPermission
        }
    }

    @ViewBuilder
    private var contactsPickerView: some View {
        let sections: [ContactsPickerSection<User>] = [.localContacts(title: "My Contacts",
                                                                      actionKind: .sendMessage(title: "invite", body: "Hey buddy, join me to this cool app!"))]

        ContactsPicker<User, EmptyView>(sections: sections) { contact, actionResult in
            print("Contact tapped: \(contact)")
        }
    }

    private var permissionView: some View {
        PermissionPromptView(permissionsService.contactsPermissionStatus == .notDetermined ? .preprompt(reoptinFallback: true) : .reoptin,
                             for: .contacts,
                             title: permissionsService.contactsPermissionStatus == .notDetermined ? "We need to access your address book" : "Without this permission you can't invite your friends !") { hasGranted in
            hasGrantedContactsPermission = hasGranted
        }
    }
}

#Preview {
    ContactsPickerDemoView()
}

extension ContactsPicker<User, EmptyView>.ContactActionResult {
    var name: String {
        switch self {
        case .messageSent: "Message sent"
        case .contactSelected: "Contact selected"
        case .contactUnselected: "Contact unselected"
        }
    }
}
