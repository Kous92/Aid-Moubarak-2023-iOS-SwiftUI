//
//  EidMubarakAudioPlayer.swift
//  AidElFitr2023
//
//  Created by Koussaïla Ben Mamar on 19/04/2023.
//

import Foundation
import AVKit

class EidMubarakAudioPlayer {
    private var audioPlayer: AVAudioPlayer?
    
    private func loadMP3Media() {
        print("Chargement du fichier audio")
        guard let url = Bundle.main.url(forResource: "TabkiratAlEid", withExtension: ".mp3") else {
            return
        }
        
        do {
            self.audioPlayer = try AVAudioPlayer(contentsOf: url)
        } catch {
            print("Une erreur est survenue lors de l'initialisation du player audio: \(error.localizedDescription)")
        }
        
        print("Succès.")
    }
    
    init() {
        loadMP3Media()
    }
    
    func playMP3Media() {
        guard let audioPlayer else {
            return
        }
        
        print("Lecture du fichier MP3")
        audioPlayer.play()
    }
}
