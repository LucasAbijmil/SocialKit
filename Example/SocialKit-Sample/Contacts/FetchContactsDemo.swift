//
//  FetchContactsDemo.swift
//  ContactsKit-Sample
//
//  Created by Michel-Andre Chirita on 13/10/2024.
//

import SwiftUI
import SocialKit
import PermissionsKit

struct FetchContactsDemo: View {

    private let contactsSerivce = LocalContactsService()
    @State private var contacts: [LocalContact] = []
    private let permissionService = PermissionsService()
    @State private var hasGrantedPermission: Bool? = nil

    var body: some View {
        Group {
            if hasGrantedPermission == true {
                List(contacts) { contact in
                    Text(contact.displayName ?? "- No name -")
                }
            } else {
                Text("You must give the app permission to access your contacts.")
            }
        }
        .task {
            hasGrantedPermission = await permissionService.askContactsPermission()
            guard hasGrantedPermission == true else { return }
            do {
                contacts = try await contactsSerivce.fetchAllLocalContacts()
            } catch {
                print("An error occurred: \(error.localizedDescription)")
            }
        }
    }
}

#Preview {
    FetchContactsDemo()
}
