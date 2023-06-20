//
//  FavoritesManager.swift
//  OffersIbotta
//
//  Created by Mariia on 6/19/23.
//

import Foundation

enum FavoritesErrors: Error {
    case urlPathGeneration
}

final class FavoritesManager {
    
    static let shared = FavoritesManager()
        
    private(set) var favorites: Observable<Set<Int>> = Observable([])
    private let favoritesFileName = "favorites.json"
    
    func isFavorite(_ itemID: Int) -> Bool {
        return favorites.value.contains(itemID)
    }
    
    func toggleFavorite(_ itemID: Int) {
        if favorites.value.contains(itemID) {
            favorites.value.remove(itemID)
        } else {
            favorites.value.insert(itemID)
        }
    }
    
    func saveFavorites() {
        // Convert favorites set to data and save it to a file
        do {
            let data = try JSONEncoder().encode(favorites.value)
            let fileURL = try getFavoritesFileURL()
            try data.write(to: fileURL)
        } catch {
            print("Error saving favorites to file: \(error)")
        }
    }
    
    func loadFavorites() {
        // Retrieves favorites set from file at App launch
        do {
            let fileURL = try getFavoritesFileURL()
            let data = try Data(contentsOf: fileURL)
            favorites.value = try JSONDecoder().decode(Set<Int>.self, from: data)
        } catch {
            print("Error loading favorites: \(error.localizedDescription)")
        }
    }
}

private extension FavoritesManager {
    func getFavoritesFileURL() throws -> URL {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            throw FavoritesErrors.urlPathGeneration
        }
        return documentsDirectory.appendingPathComponent(favoritesFileName)
    }
}
