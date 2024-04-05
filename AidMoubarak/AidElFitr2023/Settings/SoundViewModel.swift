//
//  SoundViewModel.swift
//  AidElFitr2023
//
//  Created by Koussaïla Ben Mamar on 26/03/2024.
//

import Foundation
import SwiftUI

struct SoundViewModel: Identifiable, Hashable {
    let id: Int
    let soundName: String
    let audioFileURL: String
    let audioFileName: String
    let fileSize: Int
    var isSelected: Bool = false
    var isDownloaded: Bool = false
    var isPlaying: Bool = false
}
