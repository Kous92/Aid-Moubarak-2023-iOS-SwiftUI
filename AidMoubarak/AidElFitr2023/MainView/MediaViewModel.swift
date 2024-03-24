//
//  MediaViewModel.swift
//  AidElFitr2023
//
//  Created by Koussaïla Ben Mamar on 19/04/2023.
//

import Foundation

struct MediaViewModel {
    let message: String
    let imageName: String
    let colorText: String
    let shadowColor: String
    let goldEffect: Bool
    
    init(message: String, imageName: String, colorText: String, shadowColor: String, goldEffect: Bool) {
        self.message = message
        self.imageName = imageName
        self.colorText = colorText
        self.shadowColor = shadowColor
        self.goldEffect = goldEffect
    }
    
    init(with media: EidMedia) {
        self.message = media.message
        self.imageName = media.imageName
        self.colorText = media.colorText
        self.shadowColor = media.shadowColor
        self.goldEffect = media.goldEffect
    }
}
