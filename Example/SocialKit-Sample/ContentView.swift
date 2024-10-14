//
//  ContentView.swift
//  SocialKit-Sample
//
//  Created by Michel-Andre Chirita on 14/10/2024.
//

import SwiftUI
import SocialKit

struct ContentView: View {

    @StateObject var appRatingService = AppRatingService()

    var body: some View {
        NavigationStack {
            List {
                Section("Contacts") {
                    NavigationLink {
                        FetchContactsDemo()
                    } label: {
                        Text("Fetch contacts")
                    }

                    NavigationLink {
                        ContactsPickerDemoView()
                    } label: {
                        VStack(alignment: .leading) {
                            Text("ContactsPicker")
                            Text("Permission prompts before")
                                .font(.caption)
                        }
                    }

                    NavigationLink {
                        ContactsPickerDemoView2()
                    } label: {
                        VStack(alignment: .leading) {
                            Text("ContactsPicker")
                            Text("Permission prompts embedded")
                                .font(.caption)
                        }
                    }
                }

                Section("App") {
                    NavigationLink {
                        AppRatingDemo()
                            .environmentObject(appRatingService)
                    } label: {
                        Text("AppRating")
                    }
                }
                .disabled(true)

                Section("Share") {
                    NavigationLink {
                        ShareContentDemo()
                    } label: {
                        Text("ShareContent")
                    }
                }
                .disabled(true)
            }
        }
    }
}

#Preview {
    ContentView()
}
