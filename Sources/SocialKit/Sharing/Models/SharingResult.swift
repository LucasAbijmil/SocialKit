//
//  SharingResult.swift
//  SocialKit
//
//  Created by Lucas Abijmil on 16/10/2024.
//

public enum SharingResult {
    case clipboard
    case social(SocialApp)
    case message(isSent: Bool)
    case other(isShared: Bool)
}
