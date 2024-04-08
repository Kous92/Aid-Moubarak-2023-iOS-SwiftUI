//
//  NetworkManager.swift
//  AidElFitr2023
//
//  Created by Koussaïla Ben Mamar on 28/03/2024.
//

import Foundation

final class NetworkManager {
    private var cacheKey = ""
    private let soundCache = FileCache<[AudioContent]>(fileName: "sound_cache_data", expirationInterval: 28800) // 8 hours before expiration
    
    init() {
        Task(priority: .userInitiated) {
            print("[NetworkManager] Initializing file caches")
            await soundCache.loadFromDisk()
        }
    }
    
    func fetchAudioData(forceRefresh: Bool = false) async throws -> [AudioContent] {
        cacheKey = "sounds"
        
        print("[NetworkManager] Refresh data: \(forceRefresh ? "Enabled": "Disabled")")
        
        if forceRefresh == false {
            print("[NetworkManager] Checking cached data for key: \(cacheKey)")
            if let audioContent = await soundCache.value(key: cacheKey) {
                print("[NetworkManager] Cached data found, \(audioContent.count) sounds available. Skipping download process.")
                return audioContent
            }
            
            print("[NetworkManager] No data in cache for \(cacheKey)")
        }
        
        
        guard let url = URL(string: "http://kous92.free.fr/api/EidTakbirAudioData.php") else {
            throw APIError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = (response as? HTTPURLResponse) else {
            print("[NetworkManager] Network error.")
            throw APIError.networkError
        }
        
        guard httpResponse.statusCode == 200 else {
            print("Erreur code \(httpResponse.statusCode).")
            switch httpResponse.statusCode {
            case 400:
                throw APIError.parametersMissing
            case 404:
                throw APIError.notFound
            case 500:
                throw APIError.serverError
            default:
                throw APIError.unknown
            }
        }
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        var audioContent = [AudioContent]()
        
        do {
            let output = try decoder.decode(AudioData.self, from: data)
            audioContent = output.data
        } catch {
            throw APIError.decodeError
        }
        
        print("[SuperNewsNetworkAPIService] Saving \(audioContent.count) downloaded sounds data to local cache, key: \(cacheKey)")
        await soundCache.setValue(audioContent, key: cacheKey)
        await soundCache.saveToDisk()
        
        print(audioContent)
        return audioContent
    }
    
    func checkFile(with fileName: String) {
        guard let directory = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).first else {
            print("Erreur emplacement dossier Librairie")
            return
        }
        
        let soundDirectoryPath = directory.appendingPathComponent("Sounds")
        
        // Création du dossier
        do {
            try FileManager.default.createDirectory(atPath: soundDirectoryPath.absoluteString, withIntermediateDirectories: true, attributes: nil)
            print("Dossier créé à \(soundDirectoryPath.absoluteString)")
        } catch let error as NSError {
            print("Erreur lors de la création du dossier: \(error.localizedDescription)");
        }
    }
    
    func downloadAudioFile(fileURL: String) async throws {
        guard let url = URL(string: fileURL) else {
            return
        }
        
        let fileName = url.lastPathComponent
        print("Téléchargement du fichier: \(fileName)...")
        
        var documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        documentsURL.appendPathComponent(fileName)
        
        guard !FileManager().fileExists(atPath: documentsURL.path) else {
            print("Le fichier existe déjà.")
            return
        }
        
        print("Fichier non existant")
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = (response as? HTTPURLResponse) else {
            print("Erreur réseau")
            throw APIError.networkError
        }
        
        guard let downloadedFileName = response.suggestedFilename, httpResponse.statusCode == 200 else {
            throw APIError.downloadError
        }
        
        print("OK, prêt à la sauvegarde pour le fichier \(downloadedFileName)")
        print("\(Double(response.expectedContentLength) / 1000000) MB")
        
        // Sauvegarde
        print("Sauvegarde de \(downloadedFileName)")
        print(documentsURL)
        
        do {
            try data.write(to: documentsURL, options: Data.WritingOptions.atomic)
            print("OK, sauvegardé.")
        } catch (let writeError) {
            print("Erreur lors du décodage et de la sauvegarde du fichier \(documentsURL) : \(writeError)")
            throw APIError.decodeError
        }
    }
}
