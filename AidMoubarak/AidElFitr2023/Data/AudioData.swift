//
//  AudioData.swift
//  AidElFitr2023
//
//  Created by Koussaïla Ben Mamar on 28/03/2024.
//

import Foundation

struct AudioData: Decodable {
    let data: [AudioContent]
}

struct AudioContent: Decodable {
    let id: Int
    let audioFileURL: String
    let description: String
    let fileSizeMB: Int
}
