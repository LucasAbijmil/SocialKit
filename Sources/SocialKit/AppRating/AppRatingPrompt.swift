//
//  SwiftUIView.swift
//  SocialKit
//
//  Created by Michel-Andre Chirita on 14/10/2024.
//

import SwiftUI
import StoreKit

public struct AppRatingPrompt: View {

    public enum Outcome {
        case likedAndReview
        case likedAndAppStore
        case disliked(note: String)
        case closedWithoutResponse
    }

    static var configuration: AppRatingConfiguration = .init()
    static var theme: AppRatingTheme = .init()
    @State private var displayFeedback: Bool = false
    static var closeAction: ((Outcome)->Void)? = nil

    public static func setupAppRating(configuration: AppRatingConfiguration = .init(),
                                      theme: AppRatingTheme = .init(),
                                      closeAction: ((Outcome)->Void)? = nil) {
        Self.configuration = configuration
        Self.theme = theme
        Self.closeAction = closeAction
    }

    @State private var service: AppRatingService?
    private let prePromptStyle: AppRatingPrePromptStyle
    private let theme: AppRatingTheme
    private let closeAction: ((Outcome)->Void)?

    init(service: AppRatingService? = nil,
         style: AppRatingPrePromptStyle? = nil,
         theme: AppRatingTheme = Self.theme,
         closeAction: ((Outcome)->Void)? = nil) {
        self.service = service
        self.theme = theme
        self.prePromptStyle = style ?? Self.configuration.prePromptStyle
        self.closeAction = closeAction ?? Self.closeAction
    }

    public var body: some View {
        ZStack {
            Rectangle()
                .fill(.thinMaterial)
                .onAppear {
                    if case .noPreprompt = prePromptStyle {
                        presentReviewRequest()
                    }
                }
                .onTapGesture {
                    closePrompt(outcome: .closedWithoutResponse)
                }

            switch prePromptStyle {
            case .noPreprompt:
                EmptyView()

            case .classic(let withFeedback):
                VStack {
                    Spacer()
                    prePromptView
                    Spacer()
                }
            }
        }
        .sheet(isPresented: $displayFeedback) {
            AppRatingMessageFeedbackView(theme: theme) { message in
                closePrompt(outcome: .disliked(note: message))
            }
        }
    }

    @ViewBuilder
    private var prePromptView: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(theme.primaryBackgroundColor)
            .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
            .overlay {
                VStack(spacing: 0) {
                    Text(theme.title)
                        .font(theme.titleFont)
                        .foregroundStyle(theme.primaryForegroundColor)

                    if let imageName = theme.imageRessourceName {
                        Image(imageName, bundle: .main)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200, height:  200)
                            .padding()
                    }

                    Text(theme.text)
                        .font(theme.textFont)
                        .foregroundStyle(theme.primaryForegroundColor)
                        .multilineTextAlignment(.center)
                        .padding(.top, 20)
                        .padding(.bottom, 40)
                        .padding(.horizontal)

                    HStack(spacing: 30) {
                        Spacer()
                        Button {
                            displayFeedback = true
                        } label: {
                            Text(theme.noButton)
                                .font(theme.buttonFont)
                                .foregroundStyle(theme.primaryBackgroundColor)
                                .frame(minWidth: 60)
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(theme.secondaryButtonColor)

                        Button {
                            presentReviewRequest()
                        } label: {
                            Text(theme.yesButton)
                                .font(theme.buttonFont)
                                .foregroundStyle(theme.primaryBackgroundColor)
                                .frame(minWidth: 60)
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(theme.primaryButtonColor)
                        Spacer()
                    }
                }
                .padding()
            }
            .frame(height: 250 + (theme.imageRessourceName != nil ? 240 : 0))
            .padding(.horizontal, 40)
    }

    private func presentReviewRequest() {
        if service?.fallbackOnAppStoreReview != true {
            nativeReview()
        } else {
            reviewOnAppStore()
        }
    }

    private func nativeReview() {
        service?.newEvent(.rateWithNativePrompt)
        if #available(iOS 18, *),
            let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            AppStore.requestReview(in: windowScene)
        } else {
            SKStoreReviewController.requestReview()
        }
        closePrompt(outcome: .likedAndReview)
    }

    private func reviewOnAppStore() {
        guard let appId = Self.configuration.appId,
              let writeReviewURL = URL(string: "https://apps.apple.com/app/id\(appId)?action=write-review")
        else { return  }
        service?.newEvent(.rateInAppStore)
        closePrompt(outcome: .likedAndAppStore)
        UIApplication().open(writeReviewURL, options: [:], completionHandler: nil)
    }

    private func closePrompt(outcome: Outcome) {
        service?.presentPrompt = false
        closeAction?(outcome)
    }
}

#Preview {
    AppRatingPrompt()
}
