//
//  Sharing.swift
//  SocialKit
//
//  Created by Lucas Abijmil on 15/10/2024.
//

import SwiftUI

public extension EnvironmentValues {
    @Entry var sharing = Sharing()
}

public struct Sharing {
    public func instagram(url: URL) {
        UIApplication.shared.open(Social.url(for: .instagram(url.absoluteString, isURL: true)))
    }

    public func instagram(text: String) {
        UIApplication.shared.open(Social.url(for: .instagram(text, isURL: false)))
    }

    public func whatsApp(text: String) {
        UIApplication.shared.open(Social.url(for: .whatsApp(text)))
    }
    
    public func telegram(text: String) {
        UIApplication.shared.open(Social.url(for: .telegram(text)))
    }

    public func twitter(text: String) {
        UIApplication.shared.open(Social.url(for: .twitter(text)))
    }

    public func messenger(url: URL) {
        UIApplication.shared.open(Social.url(for: .messenger(url)))
    }
}
