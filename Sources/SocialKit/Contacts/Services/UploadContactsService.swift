////
////  File.swift
////  ContactsKit
////
////  Created by Michel-André Chirita on 03/10/2024.
////
//
//import Foundation
//import PhoneNumberKit
//
//protocol UploadContactsWorker {
//    func upload(request: [LocalContact]) async throws
//}
//
//protocol UserRepository {
//    func uploadContacts(phoneNumbers: [String])
//}
//
//final class UploadContactsWorkerImpl: UploadContactsWorker {
//    
////    @Injected var appState: AppState
//    private var userRepository: UserRepository
//    public lazy var phoneNumberKit = PhoneNumberKit()
//    public lazy var phoneNumberFormatter: PartialFormatter = PartialFormatter(phoneNumberKit: phoneNumberKit)
//    private let batchSize = 30
//    
//    init(userRepository: UserRepository) {
//        self.userRepository = userRepository
//    }
//    
//    func upload(request: [LocalContact]) async throws {
////        guard let currentUser = try? await appState.currentUser() else { throw MediaWorkerError.userNotAuthentified }
//
////        log.info(label: "UploadContactsWorker", "Will upload contacts: \(request.count)")
//        
//        let contacts = request.flatMap { contact -> [String] in
//            let phoneNumbers = contact.phoneNumbers.map { self.format(phoneNumber: $0) }.compactMap { $0 }
//            return phoneNumbers
//        }
//        
//        let batches = stride(from: 0, to: contacts.count, by: self.batchSize).map { batchIndex -> [String] in
//            let endIndex = Swift.min(batchIndex + self.batchSize, contacts.count)
//            return Array(contacts[batchIndex..<endIndex])
//        }
//        
//        try await withThrowingTaskGroup(of: Void.self) { requests in
//            for batch in batches {
//                requests.addTask{
//                    try await self.userRepository.uploadContacts(phoneNumbers: batch)
//                    return
//                }
//            }
//                        
//            for try await request in requests {}
//        }
//    }
//    
//    // MARK: - Private functions
//    
//    private func format(phoneNumber string: String?) -> String? {
//        guard let string = string,
//              let phoneNumber = try? phoneNumberKit.parse(string,
//                                                          withRegion: phoneNumberFormatter.currentRegion) else { return nil }
//        
//        return phoneNumberKit.format(phoneNumber, toType: .e164)
//    }
//    
//}
