//
//  SharingView.swift
//  SocialKit
//
//  Created by Lucas Abijmil on 15/10/2024.
//

import SwiftUI

public struct SharingView: View {
    private let socialButtonsCountPerRow: Int
    private let spacing: CGFloat
    private let socialLabelSpacing: CGFloat
    private let isSocialLabelHidden: Bool
    private let socialRadius: CGFloat
    private let margin: CGFloat
    private let primaryShapeStyle: any ShapeStyle
    private let secondaryShapeStyle: any ShapeStyle
    private let backgroundShapeStyle: any ShapeStyle
    private let backgroundRadius: CGFloat
    private let font: Font
    private let onCopyLink: () async -> Void
    private let onMessage: () async -> Void
    private let onInstagram: () async -> Void
    private let onWhatsApp: () async -> Void
    private let onTelegram: () async -> Void
    private let onTwitter: () async -> Void
    private let onMessenger: () async -> Void
    private let onMore: () async -> Void
    private var gridItemSize: CGFloat {
        let availableSpace = UIScreen.main.bounds.width - (Double(socialButtonsCountPerRow) - 1.0) - (margin * 2)
        return availableSpace / Double(socialButtonsCountPerRow)
    }
    private var socialIconFrame: CGFloat {
        return gridItemSize / 2
    }

    public init(
        socialButtonsCountPerRow: Int = 4,
        spacing: Double = 16.0,
        socialLabelSpacing: Double = 4.0,
        isSocialLabelHidden: Bool = false,
        socialRadius: CGFloat = 30.0,
        margin: Double = 16.0,
        primaryShapeStyle: any ShapeStyle = .foreground,
        secondaryShapeStyle: any ShapeStyle = .background.opacity(0.75),
        backgroundShapeStyle: any ShapeStyle = .quaternary,
        backgroundRadius: CGFloat = 8.0,
        font: Font = .system(size: 14, weight: .bold),
        onCopyLink: @escaping () async -> Void,
        onMessage: @escaping () async -> Void,
        onInstagram: @escaping () async -> Void,
        onWhatsApp: @escaping () async -> Void,
        onTelegram: @escaping () async -> Void,
        onTwitter: @escaping () async -> Void,
        onMessenger: @escaping () async -> Void,
        onMore: @escaping () async -> Void
    ) {
        self.socialButtonsCountPerRow = socialButtonsCountPerRow
        self.spacing = spacing
        self.socialLabelSpacing = socialLabelSpacing
        self.isSocialLabelHidden = isSocialLabelHidden
        self.socialRadius = socialRadius
        self.margin = margin
        self.primaryShapeStyle = primaryShapeStyle
        self.secondaryShapeStyle = secondaryShapeStyle
        self.backgroundShapeStyle = backgroundShapeStyle
        self.backgroundRadius = backgroundRadius
        self.font = font
        self.onCopyLink = onCopyLink
        self.onMessage = onMessage
        self.onInstagram = onInstagram
        self.onWhatsApp = onWhatsApp
        self.onTelegram = onTelegram
        self.onTwitter = onTwitter
        self.onMessenger = onMessenger
        self.onMore = onMore
    }

    public var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.fixed(gridItemSize), spacing: .zero), count: socialButtonsCountPerRow), spacing: spacing) {
            custom(text: "Copy link", systemImage: "link", action: onCopyLink)
            social(text: "Message", image: .message, action: onMessage)
            social(text: "Instagram", image: .instagram, action: onMessage)
            social(text: "WhatsApp", image: .whatsApp, action: onWhatsApp)
            social(text: "Telegram", image: .telegram, action: onTelegram)
            social(text: "Twitter", image: .twitter, action: onTwitter)
            social(text: "Messenger", image: .messenger, action: onMessenger)
            custom(text: "More", systemImage: "ellipsis", action: onMore)
        }
        .lineLimit(1)
        .padding(.vertical, margin)
        .background(AnyShapeStyle(backgroundShapeStyle))
        .clipShape(.rect(cornerRadius: backgroundRadius))
        .padding(.horizontal, margin)
    }

    private func custom(text: String, systemImage: String, action: @escaping () async -> Void) -> some View {
        Button {
            Task {
                await action()
            }
        } label: {
            VStack(spacing: socialLabelSpacing) {
                Image(systemName: systemImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(socialIconFrame - 16)
                    .frame(socialIconFrame)
                    .background(AnyShapeStyle(secondaryShapeStyle))
                    .clipShape(.rect(cornerRadius: socialRadius))
                if !isSocialLabelHidden {
                    Text(text)
                        .font(font)
                }
            }
            .foregroundStyle(AnyShapeStyle(primaryShapeStyle))
            .frame(maxWidth: .infinity)
        }
    }

    private func social(text: String, image: ImageResource, action: @escaping () async -> Void) -> some View {
        Button {
            Task {
                await action()
            }
        } label: {
            VStack(spacing: socialLabelSpacing) {
                Image(image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(socialIconFrame)
                    .clipShape(.rect(cornerRadius: socialRadius))
                if !isSocialLabelHidden {
                    Text(text)
                        .font(font)
                }
            }
            .foregroundStyle(AnyShapeStyle(primaryShapeStyle))
            .frame(maxWidth: .infinity)
        }
    }
}

private extension View {

    func frame(_ frame: Double) -> some View {
        self
            .frame(width: frame, height: frame)
    }
}

#Preview {
    SharingView(onCopyLink: {}, onMessage: {}, onInstagram: {}, onWhatsApp: {}, onTelegram: {}, onTwitter: {}, onMessenger: {}, onMore: {})
}
