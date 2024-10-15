//
//  ShareView.swift
//  SocialKit
//
//  Created by Lucas Abijmil on 15/10/2024.
//

import SwiftUI

public struct ShareView: UIViewControllerRepresentable {
    private let activityItems: [Any]
    private let applicationActivities: [UIActivity]?
    private let completion: ((Bool) async -> Void)?

    public init(
        activityItems: [Any],
        applicationActivities: [UIActivity]? = nil,
        _ completion: ((Bool) async -> Void)?
    ) {
        self.activityItems = activityItems
        self.applicationActivities = applicationActivities
        self.completion = completion
    }

    public func makeUIViewController(context: Context) -> UIActivityViewController {
        let viewController = UIActivityViewController(activityItems: activityItems, applicationActivities: applicationActivities)
        viewController.completionWithItemsHandler = { _, isCompleted, _, _ in
            Task {
                await completion?(isCompleted)
            }
        }
        return viewController
    }

    public func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
