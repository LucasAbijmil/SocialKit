//
//  ActivityItemSource.swift
//  SocialKit
//
//  Created by Lucas Abijmil on 16/10/2024.
//

import LinkPresentation

public final class ActivityItemSource: NSObject, UIActivityItemSource, Identifiable {
    let title: String
    let url: URL
    let icon: UIImage?
    let message: String?

    public init(title: String, url: URL, icon: UIImage? = nil, message: String? = nil) {
        self.title = title
        self.url = url
        self.icon = icon
        self.message = message
    }

    public func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        return title
    }

    public func activityViewController(
        _ activityViewController: UIActivityViewController,
        itemForActivityType activityType: UIActivity.ActivityType?
    ) -> Any? {
        return message
    }

    public func activityViewControllerLinkMetadata(_ activityViewController: UIActivityViewController) -> LPLinkMetadata? {
        let metadata = LPLinkMetadata()
        metadata.title = title
        metadata.url = url
        metadata.originalURL = url
        if let icon {
            metadata.iconProvider = NSItemProvider(object: icon)
        }
        return metadata
    }
}
