//
//  SwiftUIView.swift
//  SocialKit
//
//  Created by Michel-Andre Chirita on 14/10/2024.
//

import SwiftUI
import StoreKit

public struct AppRatingPrompt: View {

    @State var service: AppRatingService?
    @Binding var isPresented: Bool

    public init() {
        self.service = nil
        self._isPresented = .constant(true)
    }

    init(service: AppRatingService? = nil) {
        self.service = service
        self._isPresented = .constant(true)
//        self._isPresented = $service.presentPrompt
    }

    public var body: some View {
        ZStack {
            Rectangle()
                .fill(.thinMaterial)

            VStack {
                Spacer()
                content
                Spacer()
            }
        }
    }

    @ViewBuilder
    private var content: some View {
        RoundedRectangle(cornerRadius: 20)
            .frame(height: 250)
            .padding(.vertical, 40)
            .overlay {
                VStack {
                    Text("Enjoying the app ?")
                        .font(.title)

                    Text("Help us by leaving a 5-stars review on the appStore")

                    Button {
                        presentReviewRequest()
                    } label: {
                        Text("Go")
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding()
            }
    }

    private func presentReviewRequest() {
        service?.saveRateDate()
        let twoSecondsFromNow = DispatchTime.now() + 2.0
        DispatchQueue.main.asyncAfter(deadline: twoSecondsFromNow) {
            SKStoreReviewController.requestReview()
        }
    }

    private func reviewOnAppStore() {
        guard let writeReviewURL = URL(string: "https://apps.apple.com/app/idXXXXXXXXXX?action=write-review")
        else { fatalError("Expected a valid URL") }
        UIApplication().open(writeReviewURL, options: [:], completionHandler: nil)
    }
}

#Preview {
    AppRatingPrompt()
}
