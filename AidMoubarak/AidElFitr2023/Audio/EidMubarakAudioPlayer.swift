//
//  EidMubarakAudioPlayer.swift
//  AidElFitr2023
//
//  Created by Koussaïla Ben Mamar on 19/04/2023.
//

import Foundation
import AVKit

final class EidMubarakAudioPlayer {
    private var audioPlayer: AVAudioPlayer?
    private var audioRead = ""
    
    private func loadMP3Media(with audioFileName: String) {
        print("Chargement du fichier audio \(audioFileName).mp3")
        
        var documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        documentsURL.appendPathComponent(audioFileName)
        
        if FileManager().fileExists(atPath: documentsURL.path) {
            print("Le fichier \(audioFileName) existe déjà.")
        } else {
            print("Lecture impossible de \(audioFileName)")
            return
        }
        
        do {
            if audioFileName == "AlAfasyTV" {
                guard let url = Bundle.main.url(forResource: "AlAfasyTV", withExtension: ".mp3") else {
                    print("Erreur le fichier par défaut n'existe pas !")
                    return
                }
                
                self.audioPlayer = try AVAudioPlayer(contentsOf: url)
            } else {
                self.audioPlayer = try AVAudioPlayer(contentsOf: documentsURL)
            }
        } catch {
            // failed to read directory – bad permissions, perhaps?
            print("ERREUR: Fichier \(audioFileName) inexistant ou autre erreur \(error.localizedDescription)")
            return
        }
        
        print("Succès.")
    }
    
    init() {
        
    }
    
    func playMP3Media(with audioFileName: String) {
        if !audioRead.isEmpty && audioFileName != audioRead {
            self.stopMP3Media()
            self.audioPlayer = nil
        }
        
        if audioPlayer == nil {
            loadMP3Media(with: audioFileName)
        }
        
        guard let audioPlayer else {
            print("ERREUR: Lecture du fichier \(audioFileName) impossible.")
            return
        }
        
        print("Lecture du fichier MP3")
        audioRead = audioFileName
        audioPlayer.play()
    }
    
    func pauseMP3Media() {
        guard let audioPlayer else {
            return
        }
        
        print("Pause de la lecture du fichier MP3")
        audioPlayer.pause()
    }
    
    func stopMP3Media() {
        guard let audioPlayer else {
            return
        }
        
        print("Arrêt de la lecture du fichier MP3.")
        audioPlayer.stop()
    }
}
