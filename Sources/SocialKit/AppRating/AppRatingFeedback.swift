//
//  SwiftUIView.swift
//  SocialKit
//
//  Created by Michel-Andre Chirita on 16/10/2024.
//

import SwiftUI

struct AppRatingMessageFeedbackView: View {

    var theme: AppRatingTheme = .init()
    let closeAction: ((String)->Void)
    @State private var comment: String = ""
    @FocusState private var focusNotesTextField

    var body: some View {
        if #available(iOS 16.0, *) {
            content
                .presentationDetents([.medium])
        } else {
            content
        }
    }

    @ViewBuilder
    private var content: some View {
        VStack(spacing: 40) {
            VStack {
                TextField(theme.feedbackPlaceholder, text: $comment)
                    .focused($focusNotesTextField)
                    .textFieldStyle(.plain)
                    .lineLimit(5)
                    .font(.system(size: 22))
                    .padding()
                Spacer()
            }
            .background(.gray.opacity(0.2), in: .rect(cornerRadius: 20))
            .padding()
            .onAppear {
                focusNotesTextField = true
            }

            Button {
                closeAction(comment)
            } label: {
                ZStack {
                    Capsule()
                        .fill(theme.primaryButtonColor)
                    HStack {
                        Text(theme.feedbackButton)
                            .bold()
                            .foregroundStyle(theme.primaryBackgroundColor)
                        Image(systemName: "arrow.right")
                            .foregroundStyle(theme.primaryBackgroundColor)
                    }
                    .font(.system(size: 22))
                }
            }
            .frame(width: 150, height: 50)

            Spacer()
        }
        .padding()

    }
}


#Preview {
    AppRatingMessageFeedbackView(closeAction: { _ in })
}
