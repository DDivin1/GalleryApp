//
//  FavoritesAssembly.swift
//  GalleryApp
//
//  Created by Dmitry  Divin on 25.03.26.
//

import UIKit

final class FavoritesAssembly {
    
    static func assemble(coordinator: AppCoordinator) -> UIViewController {
        let favoritesStorage = FavoritesStorage()
        let viewModel = FavoritesViewModel(favoritesStorage: favoritesStorage)
        
        let viewController = FavoritesViewController(viewModel: viewModel)
        viewModel.coordinator = coordinator
        return viewController
    }
}
