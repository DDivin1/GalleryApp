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
    weak var coordinator: AppCoordinator?
    
    private let favoritesStorage: IFavoritesStorage
    private let networkService: INetworkService
    
    init(favoritesStorage: IFavoritesStorage, networkService: INetworkService) {
        self.favoritesStorage = favoritesStorage
        self.networkService = networkService
    }
    
    func loadFavorites() {
        let favoritesIDs = favoritesStorage.getAllFavoritesIds()
        
        favoritesImages = []
        
        isLoading = false
        
    }
    
    func removeFromFavorites(imageID: String) {
        favoritesStorage.toggleFavorite(id: imageID)
        loadFavorites()
    }
}
