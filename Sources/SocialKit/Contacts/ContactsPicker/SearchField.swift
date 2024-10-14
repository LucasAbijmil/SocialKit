//
//  SwiftUIView.swift
//  ContactsKit
//
//  Created by Michel-Andre Chirita on 12/10/2024.
//

import SwiftUI

struct SearchField: View {

    @Binding var searchString: String
    @State private var popSearchAnimation: Bool = false
    @FocusState private var isSearchFocused: Bool
    @EnvironmentObject var colors: ContactsPickerColors
    @EnvironmentObject var wordings: ContactsPickerWordings

    var body: some View {
        HStack {
            ZStack(alignment: isSearchFocused || !searchString.isEmpty ? .leading : .center) {
                TextField("", text: $searchString, prompt: isSearchFocused ? Text("Search...") : nil)
                    .textFieldStyle(.plain)
                    .foregroundStyle(colors.primaryForeground)
                    .submitLabel(.search)
                    .padding(.leading, 25)
                    .focused($isSearchFocused)
                    .allowsHitTesting(isSearchFocused)
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundStyle(colors.secondaryBackground)
                        .font(.system(size: 14))
                        .allowsHitTesting(false)
                    if !isSearchFocused && searchString.isEmpty {
                        Text(wordings.searchBarPlaceholder)
                            .foregroundStyle(colors.primaryForeground)
                            .allowsHitTesting(false)
                    }
                    if isSearchFocused, !searchString.isEmpty {
                        Spacer()
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(colors.secondaryBackground)
                            .font(.system(size: 18))
                            .padding(.trailing, 5)
                            .onTapGesture {
                                searchString = ""
                            }
                    }
                }
                .padding(5)
            }
            .frame(height: 45)
            .background {
                RoundedRectangle(cornerRadius: 20)
                    .foregroundStyle(colors.secondaryBackground.opacity(0.3))
            }
            .scaleEffect(popSearchAnimation ? 1.05 : 1.0)
            .animation(.bouncy(duration: 0.3, extraBounce: 0.5), value: popSearchAnimation)
            .onTapGesture {
                let hapticImpact = UIImpactFeedbackGenerator(style: .medium)
                hapticImpact.impactOccurred()
                isSearchFocused = true
            }

            if isSearchFocused || !searchString.isEmpty {
                Button {
                    searchString = ""
                    let hapticImpact = UIImpactFeedbackGenerator(style: .medium)
                    hapticImpact.impactOccurred()
                    isSearchFocused = false
                } label: {
                    Text(wordings.cancel)
                        .foregroundStyle(colors.primaryForeground)
                }
                .animation(.smooth, value: isSearchFocused)
                .transition(.move(edge: .trailing))
            }
        }
    }
}

#Preview {
    SearchField(searchString: .constant(""))
}
