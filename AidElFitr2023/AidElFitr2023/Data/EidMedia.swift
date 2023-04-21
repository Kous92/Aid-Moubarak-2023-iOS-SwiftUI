//
//  EidMedia.swift
//  AidElFitr2023
//
//  Created by Koussaïla Ben Mamar on 20/04/2023.
//

import Foundation

struct EidMedia: Decodable {
    let message: String
    let imageName: String
    let colorText: String
    let shadowColor: String
    let goldEffect: Bool
}
