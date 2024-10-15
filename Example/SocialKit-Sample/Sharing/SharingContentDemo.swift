//
//  ShareContentDemo.swift
//  SocialKit-Sample
//
//  Created by Michel-Andre Chirita on 14/10/2024.
//

import SwiftUI
import SocialKit

struct SharingContentDemo: View {
    @Environment(\.openSocial) private var openSocial
    @State private var socialButtonsCountPerRow = 4
    @State private var spacing: CGFloat = 16.0
    @State private var socialLabelSpacing: CGFloat = 4.0
    @State private var isSocialLabelHidden = false
    @State private var socialRadius: CGFloat = 30
    @State private var margin: CGFloat = 16.0
    @State private var primaryShapeStyle: Color = .primary
    @State private var secondaryShapeStyle: Color = .gray.opacity(0.3)
    @State private var backgroundShapeStyle: Color = .gray.opacity(0.25)
    @State private var backgroundRadius: CGFloat = 8.0
    @State private var isShowingMessageCompose = false
    @State private var isShowingShare = false

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                SharingView(
                    sharing: .mocks,
                    socialButtonsCountPerRow: socialButtonsCountPerRow,
                    spacing: spacing,
                    socialLabelSpacing: socialLabelSpacing,
                    isSocialLabelHidden: isSocialLabelHidden,
                    socialRadius: socialRadius,
                    margin: margin,
                    primaryShapeStyle: primaryShapeStyle,
                    secondaryShapeStyle: secondaryShapeStyle,
                    backgroundShapeStyle: backgroundShapeStyle,
                    backgroundRadius: backgroundRadius,
                    font: .system(size: 14, weight: .bold)) { sharing in
                        switch sharing {
                        case .clipboard:
                            print("Copied to clipboard")
                        case .social(let app):
                            switch app {
                            case .instagram(let text, let isURL):
                                if isURL {
                                    openSocial.instagram(text: text)
                                } else {
                                    openSocial.instagram(url: URL(string: text)!)
                                }
                            case .whatsApp(let text):
                                openSocial.whatsApp(text: text)
                            case .telegram(let text):
                                openSocial.telegram(text: text)
                            case .twitter(let text):
                                openSocial.twitter(text: text)
                            case .messenger(let url):
                                openSocial.messenger(url: url)
                            }
                        case .message:
                            isShowingMessageCompose = MessageView.canSendMessage
                        case .other:
                            isShowingShare = true
                        }
                    }
                Divider()
                Group {
                    Stepper("socialButtonsCountPerRow: \(socialButtonsCountPerRow)", value: $socialButtonsCountPerRow)
                    slider(title: "spacing", value: $spacing, in: 0...40)
                    slider(title: "socialLabelSpacing", value: $socialLabelSpacing, in: 0...20)
                    Toggle("isSocialLabelHidden", isOn: $isSocialLabelHidden)
                    slider(title: "socialRadius", value: $socialRadius, in: 0...30)
                    slider(title: "margin", value: $margin, in: 0...40)
                    ColorPicker("primaryShapeStyle", selection: $primaryShapeStyle)
                    ColorPicker("secondaryShapeStyle", selection: $secondaryShapeStyle)
                    ColorPicker("backgroundShapeStyle", selection: $backgroundShapeStyle)
                    slider(title: "backgroundRadius", value: $backgroundRadius, in: 0...40)
                }
                .padding(.horizontal, 16)
            }
        }
        .scrollBounceBehavior(.basedOnSize)
        .sheet(isPresented: $isShowingMessageCompose) {
            MessageView(recipient: "", body: "") { _ in }
        }
    }

    private func slider(title: String, value: Binding<CGFloat>, in range: ClosedRange<CGFloat>) -> some View {
        LabeledContent("\(title): \(Int(value.wrappedValue))") {
            Slider(value: value, in: range, step: 1)
        }
    }
}

private extension URL {

    init(staticString: String) {
        self.init(string: "\(staticString)")!
    }
}

#Preview {
    SharingContentDemo()
}
