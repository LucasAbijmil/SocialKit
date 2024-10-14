//
//  File.swift
//  ContactsKit
//
//  Created by Michel-André Chirita on 08/10/2024.
//

import SwiftUI

public enum Photo {
    case url(URL)
    case data(Data)
    case image(UIImage)
    case asset(String)
    case none

    var isEmpty: Bool {
        switch self {
        case .none: true
        default: false
        }
    }
}
