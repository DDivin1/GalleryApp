//
//  ImageDetailViewModel.swift
//  GalleryApp
//
//  Created by Dmitry  Divin on 25.03.26.
//

import Foundation
import Combine

final class ImageDetailViewModel {
    let images: [Images]
    private(set) var currentImageIndex: Int
    weak var coordinator: AppCoordinator?
    
   @Published var favoritesIDs: Set<String> = []
    
    private let favoritesStorage: IFavoritesStorage
    
    var currentImage: Images {
        return images[currentImageIndex]
    }
    
    init (images: [Images], initialIndex: Int, favoritesStorage: IFavoritesStorage) {
        self.images = images
        self.currentImageIndex = initialIndex
        self.favoritesStorage = favoritesStorage
        self.favoritesIDs = favoritesStorage.getAllFavoritesIds()
    }
    
    func toggleFavorite(for imageID: String) {
        favoritesStorage.toggleFavorite(id: imageID)
        favoritesIDs = favoritesStorage.getAllFavoritesIds()
    }
    
    func isFavorite(for imageID: String) -> Bool {
        return favoritesIDs.contains(imageID)
    }
    
    func moveToNextImage() {
        guard currentImageIndex < images.count - 1 else { return }
        currentImageIndex += 1
    }
    
    func moveToPreviousImage() {
        guard currentImageIndex > 0 else { return }
        currentImageIndex -= 1
    }
}
