//
//  File.swift
//  ContactsKit
//
//  Created by Michel-André Chirita on 08/10/2024.
//

import Foundation

protocol User: Identifiable {
    var id: String { get }
    var displayName: String { get }
    var phoneNumber: String? { get }
    var photo: Photo? { get }
}
