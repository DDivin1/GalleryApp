//
//  ImageDetailViewModel.swift
//  GalleryApp
//
//  Created by Dmitry  Divin on 25.03.26.
//

import Foundation
import Combine

final class ImageDetailViewModel {
    
    // MARK: - Public Properties
    let images: [Images]
    @Published var currentImageIndex: Int
    weak var coordinator: AppCoordinator?
   
    var currentImage: Images {
        return images[currentImageIndex]
    }
    
    // MARK: - Private Properties
    private let favoritesStorage: IFavoritesStorage

    // MARK: - Initialization
    init (images: [Images], initialIndex: Int, favoritesStorage: IFavoritesStorage) {
        self.images = images
        self.currentImageIndex = initialIndex
        self.favoritesStorage = favoritesStorage
    }
    
    // MARK: - Public Methods
    func toggleFavorite(for imageID: String) {
        guard let image  = images.first(where: { $0.id == imageID }) else { return }
        favoritesStorage.toggleFavorite(image)
    }
    
    func isFavorite(for imageID: String) -> Bool {
        return favoritesStorage.isFavorite(id: imageID)
    }
    
    func setCurrentImageIndex(_ index: Int) {
            guard index >= 0 && index < images.count else { return }
            currentImageIndex = index
        }
    
    // MARK: - Navigation Methods
    func moveToNextImage() {
        guard currentImageIndex < images.count - 1 else { return }
        currentImageIndex += 1
    }
    
    func moveToPreviousImage() {
        guard currentImageIndex > 0 else { return }
        currentImageIndex -= 1
    }
}
