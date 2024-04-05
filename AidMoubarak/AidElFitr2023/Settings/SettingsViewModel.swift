//
//  SettingsViewModel.swift
//  AidElFitr2023
//
//  Created by Koussaïla Ben Mamar on 26/03/2024.
//

import Foundation

@MainActor
final class SettingsViewModel: ObservableObject {
    @Published var audioViewModels = [SoundViewModel]()
    @Published var isFetching = false
    @Published var isDownloading = false
    @Published var downloadProgress = ""
    @Published var isSelected = 0
    
    private let audioPlayer = EidMubarakAudioPlayer()
    private let networkManager = NetworkManager()
    private var playingAudio = ""
    
    func fetchAudioData() async {
        print("Téléchargement des données")
        isFetching = true
        
        do {
            let data = try await networkManager.fetchAudioData()
            await parseViewModels(with: data)
        } catch {
            print("ERREUR")
        }
    }
    
    private func parseViewModels(with data: [AudioContent]) async {
        var index = 0
        
        for audioContent in data {
            let fileName = URL(string: audioContent.audioFileURL)?.lastPathComponent ?? ""
            let isSelectedSound = await checkIfSelected(with: fileName)
            
            if isSelectedSound {
                isSelected = index
            }
            
            audioViewModels.append(SoundViewModel(id: audioContent.id, soundName: audioContent.description, audioFileURL: audioContent.audioFileURL, audioFileName: fileName, fileSize: audioContent.fileSizeMB, isSelected: isSelectedSound, isDownloaded: await audioFileExists(fileName: fileName)))
            
            index += 1
        }
        
        isFetching = false
        print("Liste des sons synchronisée, \(audioViewModels.count) disponible\(audioViewModels.count > 1 ? "s" : "")")
    }
    
    func downloadAudio(with viewModel: SoundViewModel) async {
        isDownloading = true
        downloadProgress = "Vérification du fichier..."
        guard await !audioFileExists(fileName: viewModel.soundName) else {
            print("-> Pas de téléchargement à faire pour le fichier \(viewModel.soundName).mp3")
            await updateList(with: viewModel)
            return
        }
        
        do {
            downloadProgress = "Téléchargement en cours..."
            try await networkManager.downloadAudioFile(fileURL: viewModel.audioFileURL)
            await updateList(with: viewModel)
        } catch {
            print("ERREUR")
        }
    }
    
    private func audioFileExists(fileName: String) async -> Bool {
        var documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        documentsURL.appendPathComponent(fileName)
        
        guard !FileManager().fileExists(atPath: documentsURL.path) else {
            print("Le fichier \(fileName) existe déjà.")
            return true
        }
        
        print("Le fichier \(fileName) n'existe pas.")
        return false
    }
    
    private func updateList(with viewModel: SoundViewModel) async {
        guard let index = audioViewModels.firstIndex(where: { $0 == viewModel }) else {
            print("Erreur d'actualisation...")
            
            return
        }
        
        audioViewModels[index].isDownloaded = true
        isDownloading = false
    }
    
    func playAudio(with viewModel: SoundViewModel) {
        guard viewModel.audioFileName != playingAudio else {
            print("Erreur pour la synchronisation de lecture")
            return
        }
        
        /*
        audioViewModels.forEach { audio in
            print("\(audio.soundName) -> Playing: \(audio.isPlaying)")
        }
         */
        
        for i in 0 ..< audioViewModels.count {
            if audioViewModels[i].audioFileName == viewModel.audioFileName {
                audioViewModels[i].isPlaying = true
                playingAudio = audioViewModels[i].audioFileName
            } else {
                audioViewModels[i].isPlaying = false
            }
        }
        
        /*
        print("\nAprès\n")
        audioViewModels.forEach { audio in
            print("\(audio.soundName) -> Playing: \(audio.isPlaying)")
        }
         */
        
        audioPlayer.playMP3Media(with: viewModel.audioFileName)
    }
    
    func pauseAudio() {
        audioPlayer.pauseMP3Media()
    }
    
    func saveChoice(with audio: SoundViewModel) async {
        UserDefaults.standard.set(audio.audioFileName, forKey: "savedSound")
        print("Le son \(audio.audioFileName) a été sélectionné.")
    }
    
    func checkIfSelected(with fileName: String) async -> Bool {
        guard let selected = UserDefaults.standard.string(forKey: "savedSound"), selected == fileName else {
            return false
        }
        
        return true
    }
}
