//
//  File.swift
//  ContactsKit
//
//  Created by Michel-André Chirita on 03/10/2024.
//

import Foundation
import Contacts
import PhoneNumberKit

protocol LocalContactsRepository {
    func fetchAllLocalContacts() async throws -> [LocalContact]
    func searchContactsList(phoneNumber: String) async throws -> [LocalContact]
    func searchContactsList(anyName: String) async throws -> [LocalContact]
}

final class LocalContactsRepositoryImpl: LocalContactsRepository {
    
    private var store = CNContactStore()
    public lazy var phoneNumberUtility = PhoneNumberUtility()
    public lazy var phoneNumberFormatter: PartialFormatter = PartialFormatter(utility: phoneNumberUtility)

    func fetchAllLocalContacts() async throws -> [LocalContact] {
        guard CNContactStore.authorizationStatus(for: .contacts) == .authorized else { return [] }
        let req = getContactsRequest()
        
        do {
            var contacts: [LocalContact] = []
            try self.store.enumerateContacts(with: req, usingBlock: { contact, stop in
                guard !contact.phoneNumbers.isEmpty,
                      ((!contact.givenName.isEmpty && contact.givenName != " ") || (!contact.familyName.isEmpty && contact.familyName != " ")) else { return }
                let contactInfos = self.createContact(from: contact)
                
                if !contacts.contains(where: { $0.id == contactInfos.id }) {
                    contacts.append(contactInfos)
                }
            })
            
            return contacts.sorted()
        } catch(let error) {
//            log.error(label: "LocalContactsRepository", error.localizedDescription)
            throw error
        }
    }
    
    func searchContactsList(phoneNumber: String) async throws -> [LocalContact] {
        let req = getContactsRequest()
        
        return try await withCheckedThrowingContinuation { continuation in
            DispatchQueue.global(qos: .userInitiated).async {
                do {
                    var contacts: [LocalContact] = []
                    try self.store.enumerateContacts(with: req, usingBlock: { contact, stop in

                        guard !contact.phoneNumbers.isEmpty,
                                contact.phoneNumbers.contains(where: { contactPhoneNumber in
                            contactPhoneNumber.value.stringValue == phoneNumber
                        })  else { return }
                        
                        let contactInfos = self.createContact(from: contact)
                        
                        if !contacts.contains(where: { $0.id == contactInfos.id }) {
                            contacts.append(contactInfos)
                        }
                    })
                    
                    continuation.resume(returning: contacts)
                } catch(let error) {
//                    log.error(label: "LocalContactsRepository", error.localizedDescription)
                    // TODO: Quick fix but should be handle before ask emitter(.failure(error))
                    continuation.resume(returning: [])
                }
            }
        }
    }
    
    func searchContactsList(anyName: String) async throws -> [LocalContact] {
        let req = getContactsRequest()
        
        return try await withCheckedThrowingContinuation { continuation in
            DispatchQueue.global(qos: .userInitiated).async {
                do {
                    var contacts: [LocalContact] = []
                    try self.store.enumerateContacts(with: req, usingBlock: { contact, stop in
                        
                        guard !contact.phoneNumbers.isEmpty,
                              (contact.familyName.range(of: anyName, options: .caseInsensitive) != nil ||
                                contact.givenName.range(of: anyName, options: .caseInsensitive) != nil) else { return }

                        let contactInfos = self.createContact(from: contact)
                        
                        if !contacts.contains(where: { $0.id == contactInfos.id }) {
                            contacts.append(contactInfos)
                        }
                    })
                    
                    continuation.resume(returning: contacts)
                } catch(let error) {
//                    log.error(label: "LocalContactsRepository", error.localizedDescription)
                    // TODO: Quick fix but should be handled before ask emitter(.failure(error))
                    continuation.resume(returning: [])
                }
            }
        }
    }
    
    // MARK: - Private functions
    
    private func getContactsRequest() -> CNContactFetchRequest {
        return CNContactFetchRequest(keysToFetch: [
            CNContactImageDataKey as CNKeyDescriptor,
            CNContactIdentifierKey as CNKeyDescriptor,
            CNContactFamilyNameKey as CNKeyDescriptor,
            CNContactGivenNameKey as CNKeyDescriptor,
            CNContactPhoneNumbersKey as CNKeyDescriptor
        ])
    }
    
    private func createContact(from contact: CNContact) -> LocalContact {
        let phoneNumbers = contact.phoneNumbers.map { self.formatPhoneNumber($0.value.stringValue) ?? $0.value.stringValue }
        
        return LocalContact(id: contact.identifier,
                            firstName: contact.givenName,
                            lastName: contact.familyName,
                            phoneNumbers: phoneNumbers,
                            localImageData: contact.imageData)
    }
    
    private func formatPhoneNumber(_ phoneNumber: String?) -> String? {
        guard let phoneNumber = phoneNumber,
              let phoneNumber = try? phoneNumberUtility.parse(phoneNumber,
                                                          withRegion: phoneNumberFormatter.currentRegion) else { return nil }
        
        return phoneNumberUtility.format(phoneNumber, toType: .e164)
    }
}
