//
//  User.swift
//  ContactsKit-Sample
//
//  Created by Michel-Andre Chirita on 12/10/2024.
//

import Foundation
import UIKit

struct User: Identifiable, Equatable {
    let id: UUID = UUID()
    let name: String
    let phone: String
    let photo: ImageResource
}
