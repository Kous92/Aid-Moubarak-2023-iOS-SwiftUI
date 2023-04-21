//
//  EidMubarakViewModel.swift
//  AidElFitr2023
//
//  Created by Koussaïla Ben Mamar on 19/04/2023.
//

import Foundation

class EidMubarakViewModel: ObservableObject {
    private var mediaViewModels = [MediaViewModel]()
    private let audioPlayer = EidMubarakAudioPlayer()
    var actualMediaIndex = 0
    
    func initData() {
        getMedias(with: "animationData")
        print(mediaViewModels)
    }
    
    func playAudioMedia() {
        audioPlayer.playMP3Media()
    }
    
    func getActualMediaIndex() -> Int {
        return actualMediaIndex
    }
    
    func getMediaCount() -> Int {
        return mediaViewModels.count
    }
    
    func getMediaViewModel() -> MediaViewModel {
        let i = actualMediaIndex
        
        // On prépare la prochaine animation
        actualMediaIndex += 1
        
        return mediaViewModels[i]
    }
    
    private func getFilePath(name: String) -> URL? {
        guard let path = Bundle.main.path(forResource: name, ofType: "json") else {
            print("The required file \(name).json is not available, cannot test decoding data.")
            return nil
        }
        
        return URL(fileURLWithPath: path)
    }
    
    private func decode<T: Decodable>(_ type: T.Type, from data: Data) -> T? {
        if let object = try? JSONDecoder().decode(type, from: data) {
            return object
        }
        
        return nil
    }
    
    private func getMedias(with fileName: String) {
        guard let fileURL = getFilePath(name: fileName) else {
            return
        }
        
        var medias = [EidMedia]()
        
        do {
            // Récupération des données JSON en type Data
            let data = try Data(contentsOf: fileURL)
            
            // Décodage des données JSON en objets exploitables
            medias = decode([EidMedia].self, from: data) ?? []
            medias.forEach { mediaViewModels.append(MediaViewModel(with: $0)) }
        } catch {
            print("An error has occured: \(error)")
        }
    }
}
