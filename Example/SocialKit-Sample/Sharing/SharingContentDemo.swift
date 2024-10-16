//
//  ShareContentDemo.swift
//  SocialKit-Sample
//
//  Created by Michel-Andre Chirita on 14/10/2024.
//

import SwiftUI
import SocialKit

struct SharingContentDemo: View {
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
                    font: .system(size: 14, weight: .bold)
                ) { sharingResult in
                    switch sharingResult {
                    case .clipboard:
                        print("Sharing Result: Clipboard")
                    case .social(let socialApp):
                        print("Sharing Result: \(socialApp)")
                    case .message(let isSent):
                        print("Sharing Result: Message – is sent: \(isSent)")
                    case .other(let isShared):
                        print("Sharing Result: Other – is shared: \(isShared)")
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
    }

    private func slider(title: String, value: Binding<CGFloat>, in range: ClosedRange<CGFloat>) -> some View {
        LabeledContent("\(title): \(Int(value.wrappedValue))") {
            Slider(value: value, in: range, step: 1)
        }
    }
}

#Preview {
    SharingContentDemo()
}
