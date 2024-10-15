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
        let url = SocialApp.url(for: .instagram(url.absoluteString, isURL: true))
        guard canOpen(url) else { return }
        UIApplication.shared.open(url)
    }

    public func instagram(text: String) {
        let url = SocialApp.url(for: .instagram(text, isURL: false))
        guard canOpen(url) else { return }
        UIApplication.shared.open(url)
    }

    public func whatsApp(text: String) {
        let url = SocialApp.url(for: .whatsApp(text))
        guard canOpen(url) else { return }
        UIApplication.shared.open(url)
    }
    
    public func telegram(text: String) {
        let url = SocialApp.url(for: .telegram(text))
        guard canOpen(url) else { return }
        UIApplication.shared.open(url)
    }

    public func twitter(text: String) {
        let url = SocialApp.url(for: .twitter(text))
        guard canOpen(url) else { return }
        UIApplication.shared.open(url)
    }

    public func messenger(url: URL) {
        let url = SocialApp.url(for: .messenger(url))
        guard canOpen(url) else { return }
        UIApplication.shared.open(url)
    }

    private func canOpen(_ url: URL) -> Bool {
        return UIApplication.shared.canOpenURL(url)
    }
}
