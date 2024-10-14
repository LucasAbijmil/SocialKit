//
//  SwiftUIView.swift
//  SocialKit
//
//  Created by Michel-Andre Chirita on 14/10/2024.
//

import SwiftUI

struct AppRatingModifier: ViewModifier {

    private let service: AppRatingService?
    init(service: AppRatingService? = nil) {
        self.service = service
    }

    func body(content: Content) -> some View {
        if service == nil || service?.showPrompt == true {
            content
                .overlay {
                    AppRatingPrompt(service: service)
                }
        } else {
            content
        }
    }
}

public extension View {
    func showAppRatingIfNeeded(service: AppRatingService? = nil) -> some View {
        modifier(AppRatingModifier(service: service))
    }
}

#Preview {
    Rectangle()
        .showAppRatingIfNeeded()
}
