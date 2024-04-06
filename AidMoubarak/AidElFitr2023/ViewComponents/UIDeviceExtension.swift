//
//  UIDeviceExtension.swift
//  AidElFitr2023
//
//  Created by Koussaïla Ben Mamar on 06/04/2024.
//

import Foundation
import UIKit

enum DeviceInterfaceType {
    case dynamicIsland
    case notch
    case none
}

extension UIDevice {
    var interfaceType: DeviceInterfaceType {
        guard let window = (UIApplication.shared.connectedScenes.compactMap { $0 as? UIWindowScene }.flatMap { $0.windows }.first { $0.isKeyWindow} ) else {
            return .none
        }
        
        if window.safeAreaInsets.top >= 51 && userInterfaceIdiom == .phone {
            return .dynamicIsland
        } else if window.safeAreaInsets.top >= 44 {
            return .notch
        } else if window.safeAreaInsets.left > 0 || window.safeAreaInsets.right > 0 {
            return .none
        }
        
        return .none
    }
}
