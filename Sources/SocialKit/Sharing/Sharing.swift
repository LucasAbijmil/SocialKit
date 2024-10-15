//
//  Sharing.swift
//  SocialKit
//
//  Created by Lucas Abijmil on 15/10/2024.
//

import Foundation

public enum Sharing: Identifiable, Hashable {
    case clipboard(title: String, symbol: String)
    case social(app: SocialApp)
    case message(title: String)
    case other(title: String, symbol: String)

    public var id: Self { self }
}

#if DEBUG
public extension [Sharing] {
    static var mocks: Self {
        return [
            .clipboard(title: "Copy Link", symbol: "link"),
            .other(title: "Other", symbol: "ellipsis"),
            .social(app: .instagram("coucou", isURL: false)),
            .social(app: .whatsApp("**Hello World**")),
            .social(app: .telegram("Hello World")),
            .social(app: .twitter("This is a tweet")),
            .social(app: .messenger(URL(string: "https://www.apple.com")!)),
            .message(title: "Message")
        ]
    }
}
#endif
