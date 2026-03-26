//
//  FavoritesStorage.swift
//  GalleryApp
//
//  Created by Dmitry  Divin on 25.03.26.
//

import Foundation
import Combine

protocol IFavoritesStorage {
    func getAllFavoritesIds() -> Set<String>
    func toggleFavorite(id: String)
    func isFavorite(id: String) -> Bool
    
}

final class FavoritesStorage: IFavoritesStorage {
    
    private let userDefaults = UserDefaults.standard
    private let favoritesKey = AppConstants.Strings.favoritesKey
    
    func getAllFavoritesIds() -> Set<String> {
        let ids = userDefaults.stringArray(forKey: favoritesKey) ?? []
        return Set(ids)
    }
    
    func toggleFavorite(id: String) {
        var favorites = getAllFavoritesIds()
        if favorites.contains(id) {
            favorites.remove(id)
        } else {
            favorites.insert(id)
        }
        userDefaults.set(Array(favorites), forKey: favoritesKey)
    }
    
    func isFavorite(id: String) -> Bool {
        return getAllFavoritesIds().contains(id)
    }
    
}
