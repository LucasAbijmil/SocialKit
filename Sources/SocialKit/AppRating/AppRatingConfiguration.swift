//
//  File.swift
//  SocialKit
//
//  Created by Michel-Andre Chirita on 14/10/2024.
//

import Foundation

public struct AppRatingConfiguration {

    let appId: String?
    let prePromptStyle: AppRatingPrePromptStyle
    let minAppLaunchEvents: Int
    let minMajorEvents: Int
    let minMinorEvents: Int
    let minPromptDisplayDaysInterval: Int
    let minReRateDaysInterval: Int
    let thisAppVersion: String

    public init(appId: String? = nil,
                prePromptStyle: AppRatingPrePromptStyle = .classic(withFeedback: .none),
                minAppLaunchEvents: Int = 3,
                minMajorEvents: Int = 10,
                minMinorEvents: Int = 20,
                minPromptDisplayDaysInterval: Int = 7,
                minReRateDaysInterval: Int = 100,
                thisAppVersion: String = "") {
        self.appId = appId
        self.prePromptStyle = prePromptStyle
        self.minAppLaunchEvents = minAppLaunchEvents
        self.minMajorEvents = minMajorEvents
        self.minMinorEvents = minMinorEvents
        self.minPromptDisplayDaysInterval = minPromptDisplayDaysInterval
        self.minReRateDaysInterval = minReRateDaysInterval
        self.thisAppVersion = thisAppVersion
    }
}

public enum AppRatingPrePromptStyle {
    case noPreprompt
    case classic(withFeedback: FeedbackStyle)

    public enum FeedbackStyle {
        case none
        case message(completion: MessageCompletion)

        public typealias MessageCompletion = (String)->Void
    }
}
