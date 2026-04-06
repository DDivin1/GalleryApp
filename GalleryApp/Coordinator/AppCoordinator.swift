//
//  AppCoordinator.swift
//  GalleryApp
//
//  Created by Dmitry  Divin on 25.03.26.
//

import UIKit

final class AppCoordinator {
    
    // MARK: - Private Properties
    private let window: UIWindow
    private let navigationController: UINavigationController
    
    // MARK: - Initialization
    init (window: UIWindow) {
        self.window = window
        self.navigationController = UINavigationController()
    }
    
    // MARK: - Public Methods
    func start() {
        let galleryVC = ImageGalleryAssembly.assemble(coordinator: self)
        navigationController.setViewControllers([galleryVC], animated: false)
        
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
    
    func showDetailScreen(for images: [Images], startingAt index: Int) {
        let detailAssembly = ImageDetailAssembly.assemble(
            images: images,
            initialIndex: index,
            coordinator: self,
            favoritesStorage: FavoritesStorage()
        )
        navigationController.pushViewController(detailAssembly, animated: true)
    }
    
    func showFavoritesScreen() {
        let favoritesAssembly = FavoritesAssembly.assemble(coordinator: self)
        navigationController.pushViewController(favoritesAssembly, animated: true)
    }
    
}
