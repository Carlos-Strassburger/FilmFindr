//
//  PersistanceManager.swift
//  FilmFindr
//
//  Created by Carlos Strassburger Filho on 05/01/26.
//

import Foundation

enum PersistanceActionType {
    case add, remove
}

enum PersistanceManager {
    static private let defaults = UserDefaults.standard
    private static let favoritesKey = "favorites"
    
    static func retrieveFavorites() -> [Movie] {
        guard let favoritesData = defaults.object(forKey: favoritesKey) as? Data else { return [] }
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(Array<Movie>.self, from: favoritesData)
        } catch {
            return []
        }
    }
    
    static func updateWith(favorite: Movie, actionType: PersistanceActionType, completion: @escaping (Error?) -> Void) {
        var retrievedFavorites = retrieveFavorites()
        
        switch actionType {
        case .add:
            guard !retrievedFavorites.contains(where: { $0.id == favorite.id }) else { return }
            retrievedFavorites.append(favorite)
            
        case .remove:
            retrievedFavorites.removeAll { $0.id == favorite.id }
        }
        
        save(favorites: retrievedFavorites, completion: completion)
    }
    
    static func save(favorites: [Movie], completion: @escaping (Error?) -> Void) {
        do {
            let encoder = JSONEncoder()
            let encodedFavorites = try encoder.encode(favorites)
            defaults.set(encodedFavorites, forKey: favoritesKey)
            completion(nil)
        } catch {
            completion(error)
        }
    }
}

