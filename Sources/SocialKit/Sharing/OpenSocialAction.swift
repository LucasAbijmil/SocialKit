//
//  OpenSocialAction.swift
//  SocialKit
//
//  Created by Lucas Abijmil on 15/10/2024.
//

import SwiftUI

public extension EnvironmentValues {
    @Entry var openSocial = OpenSocialAction()
}

public struct OpenSocialAction {
    public func instagram(url: URL) {
        UIApplication.shared.open(SocialApp.url(for: .instagram(url.absoluteString, isURL: true)))
    }

    public func instagram(text: String) {
        UIApplication.shared.open(SocialApp.url(for: .instagram(text, isURL: false)))
    }

    public func whatsApp(text: String) {
        UIApplication.shared.open(SocialApp.url(for: .whatsApp(text)))
    }
    
    public func telegram(text: String) {
        UIApplication.shared.open(SocialApp.url(for: .telegram(text)))
    }

    public func twitter(text: String) {
        UIApplication.shared.open(SocialApp.url(for: .twitter(text)))
    }

    public func messenger(url: URL) {
        UIApplication.shared.open(SocialApp.url(for: .messenger(url)))
    }
}
