//
//  File.swift
//  SocialKit
//
//  Created by Michel-Andre Chirita on 14/10/2024.
//

import Foundation

public final class AppRatingService: ObservableObject {

    @Published var presentPrompt: Bool = false
    private let configuration: AppRatingConfiguration
    private let userDefaults: UserDefaults = .standard
    private let dateFormatter: DateFormatter = .init()

    public init(configuration: AppRatingConfiguration = .init()) {
        self.configuration = configuration
    }

    var showPrompt: Bool {
        let lastMajorEventDate = userDefaults.object(forKey: AppRatingEvents.completedMajorEvent.rawValue) as? Date
        let intervalSinceLastEvent = abs(Date().timeIntervalSince(lastMajorEventDate ?? .distantPast))
        return intervalSinceLastEvent > Double(configuration.minDaysInterval)
    }

    func newEvent(_ event: AppRatingEvents) {
        let date = Date()
        userDefaults.set(date, forKey: event.rawValue)
    }

    func saveRateDate() {
        userDefaults.set(Date(), forKey: AppRatingEvents.rate.rawValue)
    }
}
