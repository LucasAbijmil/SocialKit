//
//  SwiftUIView.swift
//  SocialKit
//
//  Created by Michel-Andre Chirita on 14/10/2024.
//

import SwiftUI

struct AppRatingModifier: ViewModifier {

    @ObservedObject private var service: AppRatingService
    private let style: AppRatingPrePromptStyle?
    private let closeAction: ((AppRatingPrompt.Outcome)->Void)?

    init(service: AppRatingService?,
         style: AppRatingPrePromptStyle?,
         closeAction: ((AppRatingPrompt.Outcome)->Void)? = nil) {
        self.service = service ?? AppRatingService(forcePresentPrompt: true)
        self.style = style
        self.closeAction = closeAction

//        if service?.configuration.appId == nil {
//            fatalError("Expected a valid AppId")
//        }
    }

    func body(content: Content) -> some View {
        content
            .overlay {
                Group {
                    if service.presentPrompt == true {
                        AppRatingPrompt(service: service,
                                        style: style,
                                        closeAction: closeAction)
                            .transition(.opacity.combined(with: .scale(scale: 0.9)))
                    }
                }
                .animation(.easeOut(duration: 0.4), value: service.presentPrompt)
            }
    }
}

public extension View {
    
    /// Shows the app rating flow
    /// Should be applied to the screen root view
    /// - Parameter service: provide AppRatingService singleton to condition the display on accomplished criterias
    /// - Parameter style: choose to display a pre-prompt and customize its content
    func showAppRating(ifDeterminedBy service: AppRatingService? = nil,
                       style: AppRatingPrePromptStyle? = nil,
                       closeAction: ((AppRatingPrompt.Outcome)->Void)? = nil) -> some View {
        modifier(AppRatingModifier(service: service, style: style, closeAction: closeAction))
    }
}

#Preview {
    Rectangle()
        .showAppRating()
}
