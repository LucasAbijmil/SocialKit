//
//  File.swift
//  ContactsKit
//
//  Created by Michel-André Chirita on 03/10/2024.
//

import Foundation

public protocol CacheService {
    func getCachedContacts() async throws -> [LocalContact]
    func setCache(contacts: [LocalContact]) async throws
    func uploadLastSync(date: Date) async throws
}

//final class CacheServiceImpl: CacheService {
//    
//    func getCachedContacts() async throws -> [LocalContact] {
//        []
//    }
//    
//    func setCache(contacts: [LocalContact]) async throws {
//        
//    }
//    
//    func uploadLastSync(date: Date) async throws {
//
//    }
//}
