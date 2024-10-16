//
//  ShareView.swift
//  SocialKit
//
//  Created by Lucas Abijmil on 15/10/2024.
//

import SwiftUI

struct ShareView: UIViewControllerRepresentable {
    private let activityItemSource: ActivityItemSource
    private let applicationActivities: [UIActivity]?
    private let completion: ((Bool) async -> Void)?

    init(
        activityItemSource: ActivityItemSource,
        applicationActivities: [UIActivity]? = nil,
        _ completion: ((Bool) async -> Void)?
    ) {
        self.activityItemSource = activityItemSource
        self.applicationActivities = applicationActivities
        self.completion = completion
    }

    func makeUIViewController(context: Context) -> UIActivityViewController {
        let viewController = UIActivityViewController(activityItemSource: activityItemSource, applicationActivities: applicationActivities)
        viewController.completionWithItemsHandler = { _, isCompleted, _, _ in
            Task {
                await completion?(isCompleted)
            }
        }
        return viewController
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

private extension UIActivityViewController {

    convenience init(activityItemSource: ActivityItemSource, applicationActivities: [UIActivity]?) {
        self.init(activityItems: [activityItemSource, activityItemSource.url], applicationActivities: applicationActivities)
    }
}
