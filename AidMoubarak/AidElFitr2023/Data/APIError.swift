//
//  APIError.swift
//  AidElFitr2023
//
//  Created by Koussaïla Ben Mamar on 29/03/2024.
//

import Foundation

enum APIError: String, Error {
    case parametersMissing = "Erreur 400: Paramètres manquants dans la requête."
    case notFound = "Erreur 404: Aucun contenu disponible."
    case serverError = "Erreur 500: Erreur serveur."
    case apiError = "Une erreur est survenue."
    case invalidURL = "Erreur: URL invalide."
    case networkError = "Une erreur est survenue, pas de connexion Internet."
    case decodeError = "Une erreur est survenue au décodage des données téléchargées."
    case downloadError = "Une erreur est survenue au téléchargement des données."
    case fileAlreadyDownloaded = "Fichier déjà téléchargé."
    case unknown = "Erreur inconnue."
}
