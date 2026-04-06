//
//  FavoritesViewModel.swift
//  GalleryApp
//
//  Created by Dmitry  Divin on 25.03.26.
//

import Foundation
import Combine

final class FavoritesViewModel {
    
    // MARK: - Public Properties
    @Published var favoritesImages: [Images] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    weak var coordinator: AppCoordinator?
    
    // MARK: - Private Properties
    private let favoritesStorage: IFavoritesStorage
    
    // MARK: - Initialization
    init(favoritesStorage: IFavoritesStorage) {
        self.favoritesStorage = favoritesStorage
    }
    
    // MARK: - Public Methods
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
    
    func didSelectImage(at index: Int) {
        guard index < favoritesImages.count else { return }
        coordinator?.showDetailScreen(for: favoritesImages, startingAt: index)
    }
    
    func isFavorite(imageID: String) -> Bool {
        return favoritesStorage.isFavorite(id: imageID)
    }
}
