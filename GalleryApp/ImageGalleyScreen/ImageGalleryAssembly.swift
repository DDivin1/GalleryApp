//
//  ImageGalleryAssembly.swift
//  GalleryApp
//
//  Created by Dmitry  Divin on 25.03.26.
//
import UIKit

final class ImageGalleryAssembly {
    
    static func assemble(coordinator: AppCoordinator) -> UIViewController {
        
        let networkService = NetworkService()
        let favoritesStorage = FavoritesStorage()
        
        let viewModel = ImageGalleryViewModel(
            networkService: networkService,
            favoritesStorage: favoritesStorage
        )
        
        viewModel.coordinator = coordinator
        let viewController = ImageGalleryViewController(viewModel: viewModel)
        
        return viewController
    }
}
