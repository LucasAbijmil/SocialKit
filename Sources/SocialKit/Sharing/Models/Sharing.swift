//
//  Sharing.swift
//  SocialKit
//
//  Created by Lucas Abijmil on 15/10/2024.
//

import SwiftUI
import Foundation

public enum Sharing: Identifiable, Hashable {
    case clipboard(title: String, symbol: String, text: String)
    case social(app: SocialApp)
    case message(title: String, recipient: String?, body: String?)
    case other(title: String, symbol: String, activityItemSource: ActivityItemSource, applicationActivities: [UIActivity]? = nil)

    public var id: Self { self }
}

#if DEBUG
public extension [Sharing] {
    static var mocks: Self {
        return [
            .clipboard(title: "Copy Link", symbol: "link", text: "Text copied to clipboard"),
            .other(title: "Other", symbol: "ellipsis", activityItemSource: ActivityItemSource(title: "Test sharing", url: URL(string: "https://www.apple.com")!)),
            .social(app: .instagram("coucou", isURL: false)),
            .social(app: .whatsApp("**Hello World**")),
            .social(app: .telegram("Hello World")),
            .social(app: .twitter("This is a tweet")),
            .social(app: .messenger(URL(string: "https://www.apple.com")!)),
            .message(title: "Message", recipient: nil, body: nil)
        ]
    }
}
#endif
