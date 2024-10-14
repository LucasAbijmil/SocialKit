//
//  ContactsKit.swift
//  ContactsKit
//
//  Created by Michel-André Chirita on 03/10/2024.
//

import SwiftUI

struct RadioCheckButton: View {
    
    var isSelected: Bool
    @EnvironmentObject var colors: ContactsPickerColors

    var body: some View {
        ZStack {
            Circle()
                .stroke(colors.primaryForeground, lineWidth: 1.0)
            if isSelected {
                Circle()
                    .fill(colors.primaryForeground)
                    .padding(5)
            }
        }
        .frame(width: 20)
    }
}
#Preview {
    RadioCheckButton(isSelected: false)
}
