//
//  MessageView.swift
//  Drop
//
//  Created by Michel-André Chirita on 10/04/2024.
//

import Foundation
import SwiftUI
import UIKit
import MessageUI

public struct MessageView: UIViewControllerRepresentable {
    public static var canSendMessage: Bool {
        MFMessageComposeViewController.canSendText()
    }
    private let recipients: [String]
    private let body: String?
    private let completion: (Bool) async -> Void

    public init(recipient: String, body: String? = nil, _ completion: @escaping (Bool) async -> Void) {
        self.recipients = [recipient]
        self.body = body
        self.completion = completion
    }

    public init(recipients: [String], body: String? = nil, _ completion: @escaping (Bool) async -> Void) {
        self.recipients = recipients
        self.body = body
        self.completion = completion
    }

    public final class Coordinator: NSObject, @preconcurrency MFMessageComposeViewControllerDelegate {
        var completionResult: (Bool) async -> Void

        init(completionResult: @escaping (Bool) async -> Void) {
            self.completionResult = completionResult
        }
        
        @MainActor
        public func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
            controller.dismiss(animated: true, completion: nil)
            Task {
                await completionResult(result == .sent)
            }
        }
    }

    public func makeCoordinator() -> Coordinator {
        return Coordinator(completionResult: completion)
    }
    
    public func makeUIViewController(context: Context) -> MFMessageComposeViewController {
        let vc = MFMessageComposeViewController()
        vc.recipients = recipients
        vc.body = body
        vc.messageComposeDelegate = context.coordinator
        return vc
    }
    
    public func updateUIViewController(_ uiViewController: MFMessageComposeViewController, context: Context) {}
}
