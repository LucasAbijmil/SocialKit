//
//  Social.swift
//  SocialKit
//
//  Created by Lucas Abijmil on 15/10/2024.
//

import Foundation

enum Social {
    case instagram(String, isURL: Bool) // DM only, for stories check this (https://gist.github.com/kunofellasleep/e160c64ecea64441ffee0a6a3e18f685)
    case whatsApp(String) // Accept WhatsApp text formatting
    case telegram(String) // Accept Telegram text formatting
    case twitter(String) // Tweet only
    case messenger(URL) // URL only

    private var baseURL: String {
        switch self {
        case .instagram:
            return "instagram://"
        case .whatsApp:
            return "whatsapp://"
        case .telegram:
            return "tg://"
        case .twitter:
            return "twitter://"
        case .messenger:
            return "fb-messenger://"
        }
    }

    private var path: String {
        switch self {
        case .instagram(_, let isURL):
            return "sharesheet?" + (isURL ? "url=" : "text=")
        case .whatsApp:
            return "send?text="
        case .telegram:
            return "msg?text="
        case .twitter:
            return "/post?message="
        case .messenger:
            return "share?link="
        }
    }

    static func url(for social: Social) -> URL {
        switch social {
        case .instagram(let string, _), .whatsApp(let string), .telegram(let string), .twitter(let string):
            return URL(string: social.baseURL + social.path + string)!
        case .messenger(let url):
            return URL(string: social.baseURL + social.path + url.absoluteString)!
        }
    }
}
