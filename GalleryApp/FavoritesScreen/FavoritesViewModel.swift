//
//  FavoritesViewModel.swift
//  GalleryApp
//
//  Created by Dmitry  Divin on 25.03.26.
//

import Foundation
import Combine

final class FavoritesViewModel {
    
    @Published var favoritesImages: [Images] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    weak var coordinator: AppCoordinator?
    
    private let favoritesStorage: IFavoritesStorage
    private let networkService: INetworkService
    
    init(favoritesStorage: IFavoritesStorage, networkService: INetworkService) {
        self.favoritesStorage = favoritesStorage
        self.networkService = networkService
    }
    
    func loadFavorites() {
        isLoading = true
        favoritesImages = favoritesStorage.getAllFavorites()
        isLoading = false
    }
    
    func removeFromFavorites(imageID: String) {
        if let imageToRemove = favoritesImages.first(where: {$0.id == imageID}) {
            favoritesStorage.toggleFavorite(imageToRemove)
            loadFavorites()
        }
    }
    
    func isFavorite(imageID: String) -> Bool {
        return favoritesStorage.isFavorite(id: imageID)
    }
}
