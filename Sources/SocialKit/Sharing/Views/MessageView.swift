//
//  MessageView.swift
//  SocialKit
//
//  Created by Lucas Abijmil on 15/10/2024.
//

import SwiftUI
import MessageUI

struct MessageView: UIViewControllerRepresentable {
    static var canSendMessage: Bool {
        MFMessageComposeViewController.canSendText()
    }
    private let recipients: [String]?
    private let body: String?
    private let completion: ((Bool) async -> Void)?

    init(recipient: String? = nil, body: String? = nil, _ completion: ((Bool) async -> Void)? = nil) {
        if let recipient {
            self.recipients = [recipient]
        } else {
            self.recipients = nil
        }
        self.body = body
        self.completion = completion
    }

    final class Coordinator: NSObject, @preconcurrency MFMessageComposeViewControllerDelegate {
        private let completionResult: ((Bool) async -> Void)?

        init(completionResult: ((Bool) async -> Void)?) {
            self.completionResult = completionResult
        }
        
        @MainActor
        func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
            controller.dismiss(animated: true, completion: nil)
            Task {
                await completionResult?(result == .sent)
            }
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(completionResult: completion)
    }
    
    func makeUIViewController(context: Context) -> MFMessageComposeViewController {
        let vc = MFMessageComposeViewController()
        vc.recipients = recipients
        vc.body = body
        vc.messageComposeDelegate = context.coordinator
        return vc
    }
    
    func updateUIViewController(_ uiViewController: MFMessageComposeViewController, context: Context) {}
}
