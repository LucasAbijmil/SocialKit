//
//  SmsMessageView.swift
//  Drop
//
//  Created by Michel-André Chirita on 10/04/2024.
//

import Foundation
import SwiftUI
import UIKit
import MessageUI

struct MessageView: UIViewControllerRepresentable {

    static var canSendMessage: Bool {
        MFMessageComposeViewController.canSendText()
    }

    var recipient: String
    var messageBody: String
    var completion: (Bool) -> Void
    
    final class Coordinator: NSObject, @preconcurrency MFMessageComposeViewControllerDelegate {
        var completionResult: (Bool) -> Void
        
        init(completionResult: @escaping (Bool)->Void) {
            self.completionResult = completionResult
        }
        
        @MainActor func messageComposeViewController(_ controller: MFMessageComposeViewController,
                                   didFinishWith result: MessageComposeResult) {
            controller.dismiss(animated: true, completion: nil)
            completionResult(result == .sent)
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(completionResult: completion)
    }
    
    func makeUIViewController(context: Context) -> MFMessageComposeViewController {
        let vc = MFMessageComposeViewController()
        vc.recipients = [recipient]
        vc.body = messageBody
        vc.messageComposeDelegate = context.coordinator
        return vc
    }
    
    func updateUIViewController(_ uiViewController: MFMessageComposeViewController, context: Context) {}
    
    typealias UIViewControllerType = MFMessageComposeViewController
}
