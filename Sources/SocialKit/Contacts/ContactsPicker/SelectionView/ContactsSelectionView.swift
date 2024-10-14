//
//  SwiftUIView.swift
//  ContactsKit
//
//  Created by Michel-Andre Chirita on 13/10/2024.
//

import SwiftUI

public struct ContactsSelectionView<CustomContact: Identifiable>: View {

    @Binding var selectedContacts: [ContactsPickerContact<CustomContact>]
    @Binding var isButtonEnabled: Bool
    let buttonSystemImage: String
    let tapOnContactAction: ((ContactsPickerContact<CustomContact>) -> Void)?
    let buttonAction: (() -> Void)?
    @EnvironmentObject var colors: ContactsPickerColors

    public init(selectedContacts: Binding<[ContactsPickerContact<CustomContact>]>,
                isButtonEnabled: Binding<Bool> = .constant(false),
                buttonSystemImage: String = "chevron.forward.circle.fill",
                tapOnContactAction: ((ContactsPickerContact<CustomContact>) -> Void)? = nil,
                buttonAction: (() -> Void)? = nil) {
        self._selectedContacts = selectedContacts
        self._isButtonEnabled = isButtonEnabled
        self.buttonSystemImage = buttonSystemImage
        self.tapOnContactAction = tapOnContactAction
        self.buttonAction = buttonAction
    }

    public var body: some View {
        RoundedRectangle(cornerRadius: 20)
            .foregroundStyle(colors.primaryAccent)
            .overlay {
                ZStack {
                    scrollSelectedContacts
                        .padding(.vertical, 5)

                    HStack {
                        Spacer()
                        ZStack(alignment: .center) {
                            Rectangle()
                                .fill(LinearGradient(colors: [colors.primaryAccent.opacity(0), colors.primaryAccent], startPoint: .leading, endPoint: UnitPoint(x: 0.2, y: 0.5)))
                            if let buttonAction {
                                Button("", systemImage: buttonSystemImage) {
                                    let hapticImpact = UIImpactFeedbackGenerator(style: .medium)
                                    hapticImpact.impactOccurred()
                                    buttonAction()
                                }
                                .font(.system(size: 35))
                                .foregroundStyle(isButtonEnabled ? colors.primaryBackground : colors.primaryBackground.opacity(0.5))
                                .disabled(!isButtonEnabled)
                            }
                        }
                        .frame(width: 60)
                    }
                }
            }
            .mask({
                RoundedRectangle(cornerRadius: 20)
            })
            .frame(height: 55)
            .shadow(color: colors.primaryForeground.opacity(0.3), radius: 2, x: 1, y: 1)
            .padding()
    }

    private var scrollSelectedContacts: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(selectedContacts) { contact in
                    ContactBulle(name: contact.displayName)
                        .onTapGesture {
                            tapOnContactAction?(contact)
                        }
                }
            }
            .padding(.leading)
            .padding(.trailing, 100)
        }
    }
}

private struct ContactBulle: View {
    var name: String
    @EnvironmentObject var colors: ContactsPickerColors
    var body: some View {
        Text(name)
            .font(.system(size: 14, weight: .semibold))
            .foregroundStyle(colors.primaryForeground)
            .padding(.vertical, 5)
            .padding(.horizontal, 10)
            .background {
                RoundedRectangle(cornerRadius: 20)
                    .fill(colors.secondaryBackground)
            }
    }
}

#Preview {
    let mockContact = LocalContact(id: "", firstName: "Toto", lastName: "Titi", phoneNumbers: ["123456789"], selectedPhoneNumber: nil, localImageData: nil)
    let item = ContactsPickerItem<LocalContact>(from: mockContact)
    ContactsSelectionView(selectedContacts: .constant([ContactsPickerContact<LocalContact>.local(item)]))
}
