//
//  ImageGalleryViewModel.swift
//  GalleryApp
//
//  Created by Dmitry  Divin on 25.03.26.
//
import Combine
import UIKit

final class ImageGalleryViewModel {
    
    weak var coordinator: AppCoordinator?
    
    private let networkService: INetworkService
    private let favoritesStorage: IFavoritesStorage
    
    init (networkService: INetworkService, favoritesStorage: IFavoritesStorage) {
        self.networkService = networkService
        self.favoritesStorage = favoritesStorage
    }
    
    
    
}
