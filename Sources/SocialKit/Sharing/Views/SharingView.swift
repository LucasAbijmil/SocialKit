//
//  SharingView.swift
//  SocialKit
//
//  Created by Lucas Abijmil on 15/10/2024.
//

import SwiftUI

public struct SharingView: View {
    struct MessageComposer {
        var isActive: Bool = false
        var recipient: String?
        var body: String?
    }
    struct ShareComposer {
        var activityItemSource: ActivityItemSource?
        var applicationActivities: [UIActivity]?
    }
    @Environment(\.openSocial) private var openSocial
    @State private var messageComposer = MessageComposer()
    @State private var shareComposer = ShareComposer()
    private let sharing: [Sharing]
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
    private let completion: (SharingResult) async -> Void
    private var gridItemSize: CGFloat {
        let availableSpace = UIScreen.main.bounds.width - (Double(socialButtonsCountPerRow) - 1.0) - (margin * 2)
        return availableSpace / Double(socialButtonsCountPerRow)
    }
    private var socialIconFrame: CGFloat {
        return gridItemSize / 2
    }

    public init(
        sharing: [Sharing],
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
        completion: @escaping (SharingResult) async -> Void
    ) {
        self.sharing = sharing
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
        self.completion = completion
    }

    public var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.fixed(gridItemSize), spacing: .zero), count: socialButtonsCountPerRow), spacing: spacing) {
            ForEach(sharing) { sharing in
                Button {
                    switch sharing {
                    case let .clipboard(_, _, text):
                        UIPasteboard.general.string = text
                        Task {
                            await completion(.clipboard)
                        }
                    case let .social(app):
                        openSocial(app)
                        Task {
                            await completion(.social(app))
                        }
                    case let .message(_, recipient, body):
                        messageComposer.isActive = true
                        messageComposer.recipient = recipient
                        messageComposer.body = body
                    case let .other(_, _, activityItemSource, applicationActivities):
                        shareComposer.activityItemSource = activityItemSource
                        shareComposer.applicationActivities = applicationActivities
                    }
                } label: {
                    switch sharing {
                    case let .clipboard(title, symbol, _):
                        custom(text: title, systemImage: symbol)
                    case let .social(social):
                        switch social {
                        case .instagram:
                            app(text: "Instagram", image: .instagram)
                        case .whatsApp:
                            app(text: "WhatsApp", image: .whatsApp)
                        case .telegram:
                            app(text: "Telegram", image: .telegram)
                        case .twitter:
                            app(text: "Twitter", image: .twitter)
                        case .messenger:
                            app(text: "Messenger", image: .messenger)
                        }
                    case let .message(title, _, _):
                        app(text: title, image: .message)
                    case let .other(title, symbol, _, _):
                        custom(text: title, systemImage: symbol)
                    }
                }
            }
        }
        .lineLimit(1)
        .padding(.vertical, margin)
        .background(AnyShapeStyle(backgroundShapeStyle))
        .clipShape(.rect(cornerRadius: backgroundRadius))
        .padding(.horizontal, margin)
        .sheet(isPresented: $messageComposer.isActive) {
            MessageView(recipient: messageComposer.recipient, body: messageComposer.recipient) { isSent in
                await completion(.message(isSent: isSent))
            }
        }
//        .sheet(isPresented: $shareComposer.isActive) {
//            if let
//            ShareView(activityItemSource: shareComposer.activityItemSource, applicationActivities: shareComposer.applicationActivities) { isShared in
//                await completion(.other(isShared: isShared))
//            }
//        }
        .sheet(item: $shareComposer.activityItemSource) { activityItemSource in
            ShareView(activityItemSource: activityItemSource, applicationActivities: shareComposer.applicationActivities) { isShared in
                await completion(.other(isShared: isShared))
            }
        }
    }

    private func custom(text: String, systemImage: String) -> some View {
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

    private func app(text: String, image: ImageResource) -> some View {
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

private extension View {

    func frame(_ frame: Double) -> some View {
        self
            .frame(width: frame, height: frame)
    }
}

//#Preview {
//    SharingView(sharing: .mocks, onTap: { _ in })
//}
