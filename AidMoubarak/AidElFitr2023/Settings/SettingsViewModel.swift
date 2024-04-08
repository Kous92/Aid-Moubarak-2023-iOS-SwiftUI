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
    @Published var errorMessage = ""
    
    private let audioPlayer = EidMubarakAudioPlayer()
    private let networkManager = NetworkManager()
    private var playingAudio = ""
    
    func fetchAudioData(forceRefresh: Bool = false) async throws {
        print("Téléchargement des données")
        audioViewModels.removeAll()
        isFetching = true
        
        do {
            let data = try await networkManager.fetchAudioData(forceRefresh: forceRefresh)
            await setDefaultAudio()
            await parseViewModels(with: data)
        } catch APIError.networkError {
            errorMessage = APIError.networkError.rawValue
            throw APIError.networkError
        }
    }
    
    private func parseViewModels(with data: [AudioContent]) async {
        var index = 0
        
        // Fichier par défaut en premier
        audioViewModels.append(SoundViewModel(id: 0, soundName: "Al Afasy TV", audioFileURL: "", audioFileName: "AlAfasyTV.mp3", fileSize: 5, isSelected: false, isDownloaded: await audioFileExists(fileName: "AlAfasyTV.mp3")))
        
        index += 1
        
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
    
    private func setDefaultAudio() async {
        print("Chargement du fichier audio par défaut")
        guard let url = Bundle.main.url(forResource: "AlAfasyTV", withExtension: ".mp3") else {
            print("Erreurn le fichier par défaut n'existe pas !")
            return
        }
        
        let fileName = url.lastPathComponent
        var documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        documentsURL.appendPathComponent(fileName)
        
        print("Fichier par défaut \(fileName)")
        do {
            try FileManager.default.copyItem(at: url, to: documentsURL)
        } catch {
            print("Une erreur est survenue lors de la copie du fichier: \(error.localizedDescription)")
            return
        }
        
        print("Copie terminée du fichier par défaut.")
        
        if UserDefaults.standard.string(forKey: "savedSound") == nil {
            // Sauvegarde ici
            await saveChoice(with: "AlAfasyTV")
            isSelected = 0
        }
    }
    
    func downloadAudio(with viewModel: SoundViewModel) async {
        isDownloading = true
        downloadProgress = "\(String(localized: "checkingFile")) \(viewModel.audioFileName)"
        guard await !audioFileExists(fileName: viewModel.soundName) else {
            print("-> Pas de téléchargement à faire pour le fichier \(viewModel.soundName).mp3")
            await updateList(with: viewModel)
            return
        }
        
        do {
            downloadProgress = "\(String(localized: "downloading")) \(viewModel.audioFileName)... \(String(localized: "pleaseWait"))"
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
        
        for i in 0 ..< audioViewModels.count {
            if audioViewModels[i].audioFileName == viewModel.audioFileName {
                audioViewModels[i].isPlaying = true
                playingAudio = audioViewModels[i].audioFileName
            } else {
                audioViewModels[i].isPlaying = false
            }
        }
        
        audioPlayer.playMP3Media(with: viewModel.audioFileName)
    }
    
    func pauseAudio() {
        audioPlayer.pauseMP3Media()
    }
    
    func saveChoice(with audioFileName: String) async {
        UserDefaults.standard.set(audioFileName, forKey: "savedSound")
        print("Le son \(audioFileName) a été sélectionné.")
    }
    
    func checkIfSelected(with fileName: String) async -> Bool {
        guard let selected = UserDefaults.standard.string(forKey: "savedSound"), selected == fileName else {
            return false
        }
        
        return true
    }
}
