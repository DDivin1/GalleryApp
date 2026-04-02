//
//  FavoritesAssembly.swift
//  GalleryApp
//
//  Created by Dmitry  Divin on 25.03.26.
//

import UIKit

final class FavoritesAssembly {
    
    static func assemble(coordinator: AppCoordinator) -> UIViewController {
        
        let networkService = NetworkService()
        let favoritesStorage = FavoritesStorage()
        
        let viewModel = FavoritesViewModel(favoritesStorage: favoritesStorage, networkService: networkService)
        
        let viewController = FavoritesViewController(viewModel: viewModel)
        viewModel.coordinator = coordinator
        return viewController
    }
}
