//
//  AppCoordinator.swift
//  GalleryApp
//
//  Created by Dmitry  Divin on 25.03.26.
//

import UIKit

final class AppCoordinator {
    
    private let window: UIWindow
    private let navigationController: UINavigationController
    
    init (window: UIWindow) {
        self.window = window
        self.navigationController = UINavigationController()
    }
    
    func start() {
        let galleryVC = ImageGalleryAssembly.assemble(coordinator: self)
        navigationController.setViewControllers([galleryVC], animated: false)
        
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
    
    func showDetailScreen(for images: [Images], staringAt index: Int) {
        let detailAssembly = ImageDetailAssembly.assemble(
            images: images,
            initialIndex: index,
            coordinator: self
        )
        navigationController.pushViewController(detailAssembly, animated: true)
    }
    
}
