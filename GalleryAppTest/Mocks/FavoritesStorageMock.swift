//
//  FavoritesStorageMock.swift
//  GalleryApp
//
//  Created by Dmitry  Divin on 5.04.26.
//

@testable import GalleryApp

final class FavoritesStorageMock: IFavoritesStorage {
    
    var getAllFavoritesCalled = false
    var toggleFavoriteCalled = false
    var isFavoriteCalled = false
    var getAllFavoritesIdsCalled = false
    
    var mockFavorites: [Images] = []
    var mockFavoritesIds: Set<String> = []
    
    func getAllFavorites() -> [Images] {
        getAllFavoritesCalled = true
        return mockFavorites
    }
    
    func toggleFavorite(_ image: Images) {
        toggleFavoriteCalled = true
    }
    
    func isFavorite(id: String) -> Bool {
        isFavoriteCalled = true
        return mockFavoritesIds.contains(id)
    }
    
    func getAllFavoritesIds() -> Set<String> {
        getAllFavoritesIdsCalled = true
        return mockFavoritesIds
    }
    
    func setMocksFavorites(_ favorites: [Images]) {
        self.mockFavorites = favorites
    }
    
    func setMocksFavoritesIds(_ favoritesIds: Set<String>) {
        self.mockFavoritesIds = favoritesIds
    }
    
}
