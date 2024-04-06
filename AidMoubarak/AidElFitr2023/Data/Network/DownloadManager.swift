//
//  DownloadManager.swift
//  AidElFitr2023
//
//  Created by Koussaïla Ben Mamar on 06/04/2024.
//

import Foundation

final class DownloadManager {
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
