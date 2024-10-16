//
//  OpenSocialAction.swift
//  SocialKit
//
//  Created by Lucas Abijmil on 15/10/2024.
//

import SwiftUI

extension EnvironmentValues {
    @Entry var openSocial = OpenSocialAction()
}

struct OpenSocialAction {
    func callAsFunction(_ socialApp: SocialApp) {
        switch socialApp {
        case let .instagram(text, isURL):
            UIApplication.shared.open(SocialApp.url(for: .instagram(text, isURL: isURL)))
        case .whatsApp(let text):
            UIApplication.shared.open(SocialApp.url(for: .whatsApp(text)))
        case .telegram(let text):
            UIApplication.shared.open(SocialApp.url(for: .telegram(text)))
        case .twitter(let text):
            UIApplication.shared.open(SocialApp.url(for: .twitter(text)))
        case .messenger(let url):
            UIApplication.shared.open(SocialApp.url(for: .messenger(url)))
        }
    }
}
