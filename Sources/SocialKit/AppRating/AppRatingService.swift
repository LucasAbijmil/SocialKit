//
//  File.swift
//  SocialKit
//
//  Created by Michel-Andre Chirita on 14/10/2024.
//

import Foundation

public final class AppRatingService: ObservableObject {

    @Published var presentPrompt: Bool = false
    var fallbackOnAppStoreReview: Bool = false
    let configuration: AppRatingConfiguration
    private let userDefaults: UserDefaults = .standard

    public init(configuration: AppRatingConfiguration? = nil, forcePresentPrompt: Bool = false) {
        self.configuration = configuration ?? AppRatingPrompt.configuration
        self.presentPrompt = forcePresentPrompt
    }

    public func newEvent(_ event: AppRatingEvents) {
        switch event {
        case .appLaunch:
            let count = userDefaults.integer(forKey: key(for: event))
            userDefaults.set(count + 1, forKey: key(for: event))

        case .completedMajorEvent:
            let count = userDefaults.integer(forKey: key(for: event))
            userDefaults.set(count + 1, forKey: key(for: event))

        case .completedMinorEvent:
            let count = userDefaults.integer(forKey: key(for: event))
            userDefaults.set(count + 1, forKey: key(for: event))

        case .promptDisplay:
            savePromptDisplayDate()

        case .rateWithNativePrompt, .rateInAppStore:
            var allPreviousdates = userDefaults.array(forKey: key(for: event)) as? [Date] ?? []
            allPreviousdates.append(Date())
            userDefaults.set(allPreviousdates, forKey: key(for: event))
        }

        showIfNeeded()

#if DEBUG
        let count = userDefaults.array(forKey: key(for: event))?.count ?? userDefaults.integer(forKey: key(for: event))
        print("Event stored: \(event.rawValue), current count: \(count)")
#endif
    }

    private func showIfNeeded() {
        guard !presentPrompt else { return }

        guard checkInterval(for: .rateWithNativePrompt,
                             isMoreThan: configuration.minReRateDaysInterval)
        else { return }

        guard checkInterval(for: .rateInAppStore,
                            isMoreThan: configuration.minReRateDaysInterval)
        else { return }

        guard checkInterval(for: .promptDisplay,
                             isMoreThan: configuration.minPromptDisplayDaysInterval)
        else { return }

        checkAppReviewFallback()

        if presentIfCount(for: .appLaunch,
                          reachedMin: configuration.minAppLaunchEvents) { return }
        if presentIfCount(for: .completedMajorEvent,
                          reachedMin: configuration.minMajorEvents) { return }
        if presentIfCount(for: .completedMinorEvent,
                          reachedMin: configuration.minMinorEvents) { return }
        presentPrompt = false
    }

    private func checkInterval(for event: AppRatingEvents, isMoreThan minInterval: Int) -> Bool {
        let allPreviousDates = userDefaults.object(forKey: key(for: event)) as? [Date] ?? []
        let lastDate = allPreviousDates.last ?? .distantPast
        let intervalSinceLastDate = Calendar.current.dateComponents([.day],
                                                                    from: lastDate,
                                                                    to: Date())
        if let interval = intervalSinceLastDate.day,
            interval < minInterval {
            return false
        }
        return true
    }

    private func checkAppReviewFallback() {
        let allPreviousNativeRateDates = userDefaults.object(forKey: key(for: AppRatingEvents.rateInAppStore)) as? [Date] ?? []
        let last3 = allPreviousNativeRateDates.suffix(3)
        if last3.count == 3,
           let firstInPeriod = last3.first,
           let daysCount = Calendar.current.dateComponents([.day], from: firstInPeriod, to: Date()).day,
           daysCount <= 365 {
            fallbackOnAppStoreReview = true
        } else {
            fallbackOnAppStoreReview = false
        }
    }

    private func presentIfCount(for event: AppRatingEvents, reachedMin minCount: Int) -> Bool {
        let minAppLaunchCount = userDefaults.integer(forKey: key(for: event))
        let minAppLaunchCountReached = minAppLaunchCount >= minCount
        if minAppLaunchCountReached {
            savePromptDisplayDate()
            resetCounter(for: event)
            presentPrompt = true
            return true
        }
        return false
    }

    private func savePromptDisplayDate() {
        userDefaults.set([Date()], forKey: key(for: .promptDisplay))
    }

    private func resetCounter(for event: AppRatingEvents) {
        userDefaults.set(0, forKey: key(for: event))
    }

    private func resetCounters() {
        userDefaults.set(0, forKey: key(for: .appLaunch))
        userDefaults.set(0, forKey: key(for: .completedMajorEvent))
        userDefaults.set(0, forKey: key(for: .completedMinorEvent))
    }

    private func key(for event: AppRatingEvents) -> String {
        configuration.thisAppVersion + event.rawValue
    }
}
