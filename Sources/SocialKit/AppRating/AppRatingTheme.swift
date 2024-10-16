//
//  AppRatingTheme.swift
//  SocialKit
//
//  Created by Michel-Andre Chirita on 15/10/2024.
//

import SwiftUI

public struct AppRatingTheme {

    let primaryForegroundColor: Color
    let primaryBackgroundColor: Color
    let primaryButtonColor: Color
    let secondaryButtonColor: Color

    let title: String
    let text: String
    let noButton: String
    let yesButton: String
    let feedbackPlaceholder: String
    let feedbackButton: String

    let titleFont: Font
    let textFont: Font
    let buttonFont: Font

    let imageRessourceName: String?

    public init(
        primaryForegroundColor: Color? = nil,
        primaryBackgroundColor: Color? = nil,
        primaryButtonColor: Color? = nil,
        secondaryButtonColor: Color? = nil,
        title: String? = nil,
        text: String? = nil,
        noButton: String? = nil,
        yesButton: String? = nil,
        feedbackPlaceholder: String? = nil,
        feedbackButton: String? = nil,
        titleFont: Font? = nil,
        textFont: Font? = nil,
        buttonFont: Font? = nil,
        imageRessourceName: String? = nil
    ) {
        self.primaryForegroundColor = primaryForegroundColor ?? Color("primaryForeground", bundle: .module)
        self.primaryBackgroundColor = primaryBackgroundColor ?? Color("primaryBackground", bundle: .module)
        self.primaryButtonColor = primaryButtonColor ?? Color("primaryAccent", bundle: .module)
        self.secondaryButtonColor = secondaryButtonColor ?? Color("secondaryButton", bundle: .module)
        self.title = title ?? "Enjoying the app ?"
        self.text = text ?? "Help us by leaving a 5-stars review on the appStore"
        self.noButton = noButton ?? "Meh..."
        self.yesButton = yesButton ?? "Yeah!"
        self.feedbackPlaceholder = feedbackPlaceholder ?? "Tell us more !"
        self.feedbackButton = feedbackButton ?? "Submit"
        self.titleFont = titleFont ?? .largeTitle.bold()
        self.textFont = textFont ?? .title3.weight(.medium)
        self.buttonFont = buttonFont ?? .title2.weight(.semibold)
        self.imageRessourceName = imageRessourceName
    }
}
