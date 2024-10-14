//
//  ContactsPickerDemoView.swift
//  ContactsKit-Sample
//
//  Created by Michel-Andre Chirita on 11/10/2024.
//

import SwiftUI
import SocialKit
import PermissionsKit

struct ContactsPickerDemoView2: View {

    private let permissionsService = PermissionsService()
    @State private var hasGrantedContactsPermission: Bool? = nil
    private let users: [User] = [User(name: "Fifi", phone: "+33612345634", photo: .mockUserPicture1),
                                 User(name: "Fafa", phone: "555-478-7672", photo: .mockUserPicture2),
                                 User(name: "Loulou", phone: "+33689306517", photo: .mockUserPicture2)]
    private func item(for user: User) -> ContactsPickerItem<User> {
        .init(contact: user,
              displayName: user.name,
              secondaryDisplayName: user.phone,
              photo: .image(UIImage(resource: user.photo)),
              phoneNumbers: [user.phone])
    }
    private let colors = ContactsPickerColors(primaryForeground: .primaryText, primaryBackground: .primaryBackground, secondaryBackground: .secondaryBackground, primaryAccent: .primaryButton, seconaryAccent: .secondaryButton)
    private let wordings = ContactsPickerWordings(navBarTitle: "Demo contacts picker")
    @State private var selectedContacts: [ContactsPickerContact<User>] = []

    var body: some View {
        let sections: [ContactsPickerSection<User>] = [.customContacts(title: "Friends",
                                                                       items: users.map(item(for:)),
                                                                       actionKind: .select(title: "add friend")),
                                                       .localContacts(title: "My Contacts",
                                                                      actionKind: .select(title: "invite"))]

        ZStack {
            ContactsPicker<User, PermissionPromptView>(searchKind: .onTopOfList,
                                                       sections: sections,
                                                       selectedContacts: $selectedContacts,
                                                       hasGrantedPermission: $hasGrantedContactsPermission,
                                                       permissionView: permissionView,
                                                       colors: colors,
                                                       wordings: wordings,
                                                       contactTappedAction: userHasTapped(on:actionResult:))

            VStack {
                Spacer()
                ContactsSelectionView(selectedContacts: $selectedContacts, isButtonEnabled: .constant(selectedContacts.count > 2), tapOnContactAction: { contact in
                    selectedContacts.removeAll(where: { $0.id == contact.id })
                }, buttonAction: {
                    print("Selection button tapped with \(selectedContacts.count) contacts selected.")
                })
                .environmentObject(colors)
            }
        }
        .onAppear {
            hasGrantedContactsPermission = permissionsService.hasGrantedContactsPermission
        }
    }

    private func userHasTapped(on contact: ContactsPickerContactResult<User>, actionResult: ContactsPicker<User, PermissionPromptView>.ContactActionResult) {
        switch contact {
        case .local(let local): print("LocalContact tapped: \(String(describing: local.displayName)), \(actionResult.name)")
        case .custom(let customUser): print("Custom user tapped: \(customUser.name), \(actionResult.name)")
        }
    }

    private func permissionView() -> PermissionPromptView {
        PermissionPromptView(permissionsService.contactsPermissionStatus == .notDetermined ? .preprompt(reoptinFallback: true) : .reoptin,
                             for: .contacts,
                             title: permissionsService.contactsPermissionStatus == .notDetermined ? "We need to access your address book" : "Without this permission you can't invite your friends !") { hasGranted in
            hasGrantedContactsPermission = hasGranted
        }
    }
}

#Preview {
    ContactsPickerDemoView2()
}

extension ContactsPicker<User, PermissionPromptView>.ContactActionResult {
    var name: String {
        switch self {
        case .messageSent: "Message sent"
        case .contactSelected: "Contact selected"
        case .contactUnselected: "Contact unselected"
        }
    }
}
