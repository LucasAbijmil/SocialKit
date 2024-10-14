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

    var body: some View {
        VStack(spacing: 40) {
            Spacer()

            Button {

            } label: {
                Text("Trigger app launch event")
            }

            Button {

            } label: {
                Text("Trigger major event")
            }

            Button {

            } label: {
                Text("Trigger minor event")
            }

            Spacer()
        }
        .showAppRatingIfNeeded(service: appRatingService)
    }
}

#Preview {
    AppRatingDemo()
}
