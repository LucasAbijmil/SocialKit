//
//  File.swift
//  SocialKit
//
//  Created by Michel-Andre Chirita on 14/10/2024.
//

import Foundation

public enum AppRatingEvents: String {

    /// Triggered by the app
    case appLaunch
    case completedMajorEvent
    case completedMinorEvent

    /// Triggered by the prompt
    case promptDisplay
    case rateWithNativePrompt
    case rateInAppStore

}
