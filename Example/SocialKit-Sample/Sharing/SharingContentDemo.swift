//
//  ShareContentDemo.swift
//  SocialKit-Sample
//
//  Created by Michel-Andre Chirita on 14/10/2024.
//

import SwiftUI

struct SharingContentDemo: View {
    @Environment(\.sharing) private var sharing

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            instagram
            whatsApp
            telegram
            messenger
        }
    }

    private var instagram: some View {
        HStack(spacing: 16) {
            icon(.instagram)
            VStack(alignment: .leading, spacing: 12) {
                Button("URL") { sharing.instagram(url: URL(string: "https://wwww.apple.com")!) }
                Button("Plain text") { sharing.instagram(text: "Hello World") }
            }
        }
    }

    private var whatsApp: some View {
        HStack(spacing: 16) {
            icon(.whatsapp)
            VStack(alignment: .leading, spacing: 12) {
                Button("Formatted text") { sharing.whatsApp(text: "**Hello World**") }
                Button("Plain text") { sharing.whatsApp(text: "Hello World") }
            }
        }
    }

    private var telegram: some View {
        HStack(spacing: 16) {
            icon(.telegram)
            Button("Plain text") { sharing.telegram(text: "Hello World") }
        }
    }

    private var twitter: some View {
        HStack(spacing: 16) {
            icon(.twitter)
            Button("Plain text") { sharing.twitter(text: "Hello World") }
        }
    }

    private var messenger: some View {
        HStack(spacing: 16) {
            icon(.messenger)
            Button("URL") { sharing.messenger(url: URL(string: "https://www.apple.com")!) }
        }
    }

    private func icon(_ asset: ImageResource) -> some View {
        Image(asset)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 40, height: 40)
            .clipShape(.rect(cornerRadius: 8))
    }
}

#Preview {
    SharingContentDemo()
}
