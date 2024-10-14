//
//  File.swift
//  SocialKit
//
//  Created by Michel-Andre Chirita on 14/10/2024.
//

import Foundation

public struct AppRatingConfiguration {

    let minDaysInterval: Int
    let minAppLaunchEventsInterval: Int
    let minMajorEventsInterval: Int
    let minMinorEventsInterval: Int

    public init(minDaysInterval: Int = 7,
                minAppLaunchEventsInterval: Int = 3,
                minMajorEventsInterval: Int = 3,
                minMinorEventsInterval: Int = 3) {
        self.minDaysInterval = minDaysInterval
        self.minAppLaunchEventsInterval = minAppLaunchEventsInterval
        self.minMajorEventsInterval = minMajorEventsInterval
        self.minMinorEventsInterval = minMinorEventsInterval
    }
}
