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
    private var networkAudioPlayer: AVPlayer?
    private var audioRead = ""
    
    private func loadMP3Media(with audioFileName: String) {
        // guard let fileName = URL(stringaudioFileName)
        print("Chargement du fichier audio \(audioFileName).mp3")
        
        var documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        documentsURL.appendPathComponent(audioFileName)
        
        do {
            self.audioPlayer = try AVAudioPlayer(contentsOf: documentsURL)
        } catch {
            // failed to read directory – bad permissions, perhaps?
            print("ERREUR: Fichier \(audioFileName).mp3 inexistant ou autre erreur \(error.localizedDescription)")
            return
        }
        
        print("Succès.")
    }
    
    private func loadMP3MediaFromNetwork(with audioFileName: String) {
        print("Téléchargement du fichier audio \(audioFileName).mp3")
        
        guard let url = URL(string: "http://kous92.free.fr/AudioData/EidTakbir/AlAfasyTV.mp3") else {
            print("ERREUR: Fichier \(audioFileName).mp3 inexistant")
            return
        }
        
        let item = AVPlayerItem(url: url)
        self.networkAudioPlayer = AVPlayer(playerItem: item)
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
            print("ERREUR: Lecture du fichier \(audioFileName).mp3 impossible.")
            return
        }
        
        print("Lecture du fichier MP3")
        audioRead = audioFileName
        audioPlayer.play()
    }
    
    func playOnlineMP3Media(with audioFileName: String) {
        if networkAudioPlayer == nil {
            loadMP3MediaFromNetwork(with: audioFileName)
        }
        
        guard let networkAudioPlayer else {
            print("ERREUR: Lecture du fichier \(audioFileName).mp3 impossible.")
            return
        }
        
        print("Lecture du fichier MP3")
        networkAudioPlayer.play()
    }
    
    func pauseMP3Media() {
        guard let audioPlayer else {
            return
        }
        
        print("Pause de la lecture du fichier MP3")
        audioPlayer.pause()
    }
    
    func pauseOnlineMP3Media() {
        guard let networkAudioPlayer else {
            return
        }
        
        print("Pause de la lecture du fichier MP3")
        networkAudioPlayer.pause()
    }
    
    func stopMP3Media() {
        guard let audioPlayer else {
            return
        }
        
        print("Arrêt de la lecture du fichier MP3.")
        audioPlayer.stop()
    }
}
