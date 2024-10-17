//
//  AppRatingDemo.swift
//  SocialKit-Sample
//
//  Created by Michel-Andre Chirita on 14/10/2024.
//

import SwiftUI
import SocialKit

struct AppRatingDemo: View {

    @EnvironmentObject var appRatingService: AppRatingService
    @State var forceShowPrePrompt: Bool = false

    var body: some View {
        VStack(spacing: 10) {
            Spacer()

            Text("Simulate app events")
                .foregroundStyle(.secondaryText)
                .bold()

            VStack(spacing: 40) {
                Button {
                    appRatingService.newEvent(.appLaunch)
                } label: {
                    Text("Trigger app launch event")
                        .font(.title3)
                        .foregroundStyle(.primaryText)
                }

                Button {
                    appRatingService.newEvent(.completedMajorEvent)
                } label: {
                    Text("Trigger major event")
                        .font(.title3)
                        .foregroundStyle(.primaryText)
                }

                Button {
                    appRatingService.newEvent(.completedMinorEvent)
                } label: {
                    Text("Trigger minor event")
                        .font(.title3)
                        .foregroundStyle(.primaryText)
                }
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.primaryFormBackground, in: .rect(cornerRadius: 20))
            .padding(.horizontal, 40)

            Button {
                forceShowPrePrompt = true
            } label: {
                Text("Force display pre-prompt")
                    .font(.title3)
                    .foregroundStyle(.primaryText)
            }
            .buttonStyle(.bordered)
            .padding(.top, 40)

            Spacer()
        }
        .navigationTitle("App Rating Demo")
        .navigationBarTitleDisplayMode(.large)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.primaryBackground)
        .showAppRating(ifDeterminedBy: forceShowPrePrompt ? nil : appRatingService)
        .onAppear {
            setupAppRating()
        }
    }

    ///
    /// Do it once for all, for example at app launch
    ///
    private func setupAppRating() {
        let feedbackMessageCompletion: AppRatingPrePromptStyle.FeedbackStyle.MessageCompletion = { message in
            print("Feedback message: \(message)")
        }

        let feedback = AppRatingPrePromptStyle.FeedbackStyle.message(completion: feedbackMessageCompletion)

        let closeAction: (AppRatingPrompt.Outcome)->Void = { outcome in
            switch outcome {
            case .closedWithoutResponse: print("Closed without response")
            case .disliked(note: let message): print("Closed with message: \(message)")
            case .likedAndReview: print("Liked and seen review prompt")
            case .likedAndAppStore: print("Liked and went to appStore")
            }
            forceShowPrePrompt = false
        }

        let configuration = AppRatingConfiguration(appId: "[some app id]",
                                                   prePromptStyle: .classic(withFeedback: feedback),
                                                   thisAppVersion: "1.1.0")
        let theme = AppRatingTheme(primaryButtonColor: .red, imageRessourceName: "loveBear2")

        AppRatingPrompt.setupAppRating(configuration: configuration,
                                       theme: theme,
                                       closeAction: closeAction)
    }
}

#Preview {
    AppRatingDemo()
}
