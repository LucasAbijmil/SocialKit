//
//  File.swift
//  ContactsKit
//
//  Created by Michel-André Chirita on 03/10/2024.
//

import Foundation

public protocol LocalContactsServiceType {
    func fetchAllLocalContacts() async throws -> [LocalContact]
    func uploadAllLocalContactsIfNeeded(force: Bool) async throws
    func search(query: String) async throws -> [LocalContact]
}

public protocol UploadContactsService {
    func upload(request: [LocalContact]) async throws
}

public struct LocalContactsService: LocalContactsServiceType {

    private var repository: LocalContactsRepository = LocalContactsRepositoryImpl()
    private var uploadContactsService: UploadContactsService?
    private let cacheService: CacheService?
    private let useNativeSearch: Bool = true

    public init(cacheService: CacheService? = nil,
                uploadContactsService: UploadContactsService? = nil) {
        self.cacheService = cacheService
        self.uploadContactsService = uploadContactsService
    }
    
    public func fetchAllLocalContacts() async throws -> [LocalContact] {
        let allLocalContacts = try await repository.fetchAllLocalContacts()
        try await cacheService?.setCache(contacts: allLocalContacts)
        return allLocalContacts
    }
    
    public func uploadAllLocalContactsIfNeeded(force: Bool) async throws {
        let cachedLocalContacts = try await cacheService?.getCachedContacts() ?? []
        let localContacts = try await fetchAllLocalContacts()
        if force || localContacts.sorted() != cachedLocalContacts.sorted() {
            let updatedContacts = localContacts.symetricDifference(from: cachedLocalContacts)
//            log.debug(label: "LocalContactsWorker", "Local contacts changed \(updatedContacts.count)")
            if let uploadContactsService, updatedContacts.count > 0 {
                try await uploadContactsService.upload(request: updatedContacts)
                try await cacheService?.uploadLastSync(date: Date())
            }
        }
//        log.debug(label: "LocalContactsWorker", "Upload local contacts done.")
    }
    
    public func search(query: String) async throws -> [LocalContact] {
        let normalizedQuery = query.lowercased()
        var results: Set<LocalContact> = Set()
        
        let phoneNumberResults = try await searchContactsList(phoneNumber: query)
        results.formUnion(phoneNumberResults)

        let nameResult: [LocalContact]
        if useNativeSearch {
            nameResult = try await searchContactsList(anyName: query)
        } else {
            let localContacts = try await cacheService?.getCachedContacts() ?? []
            nameResult = localContacts.filter { $0.displayName?.lowercased().contains(normalizedQuery) == true ||
                $0.reversedDisplayName?.lowercased().contains(normalizedQuery) == true }
        }
        results.formUnion(nameResult)

        return Array(results)
    }
    
    private func searchContactsList(anyName: String) async throws -> [LocalContact] {
        try await repository.searchContactsList(anyName: anyName)
    }
    
    private func searchContactsList(phoneNumber: String) async throws -> [LocalContact] {
        try await repository.searchContactsList(phoneNumber: phoneNumber)
    }
}
