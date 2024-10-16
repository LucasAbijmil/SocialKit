//
//  UIImage+AppIcon.swift
//  SocialKit
//
//  Created by Lucas Abijmil on 16/10/2024.
//

import UIKit

public extension UIImage {

    static var appIcon: UIImage? {
        guard let icons = Bundle.main.infoDictionary?["CFBundleIcons"] as? [String: Any],
              let primaryIcon = icons["CFBundlePrimaryIcon"] as? [String: Any],
              let iconFiles = primaryIcon["CFBundleIconFiles"] as? [String],
              let lastAppIcon = iconFiles.last
        else { return nil }

        return UIImage(named: lastAppIcon)
    }
}
