//
//  AudioData.swift
//  AidElFitr2023
//
//  Created by Koussaïla Ben Mamar on 28/03/2024.
//

import Foundation

struct AudioData: Codable {
    let data: [AudioContent]
}

struct AudioContent: Codable {
    let id: Int
    let audioFileURL: String
    let description: String
    let fileSizeMB: Int
}
