//
//  Constants.swift
//  AidElFitr2023
//
//  Created by Koussaïla Ben Mamar on 19/04/2023.
//

import Foundation
import UIKit

// Soit sur iPhone, soit sur iPad
fileprivate func isPhone() -> Bool {
    return UIDevice.current.userInterfaceIdiom == .phone
}

struct Constants {
    static let goldenButtonHeight: CGFloat = isPhone() ? 55 : 100
    static let goldenButtonFontSize: CGFloat = isPhone() ? 24 : 38
    static let messageFontSize: CGFloat = isPhone() ? 30 : 50
    static let messageYposition: CGFloat = isPhone() ? 80 : 120
}
