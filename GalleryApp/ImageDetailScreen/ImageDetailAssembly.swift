//
//  ImageDetailAssembly.swift
//  GalleryApp
//
//  Created by Dmitry  Divin on 25.03.26.
//

import UIKit

final class ImageDetailAssembly {
    static func assemble(images: [Images],
                         initialIndex: Int,
                         coordinator: AppCoordinator,
                         favoritesStorage: IFavoritesStorage) -> UIViewController {
        
        let viewModel = ImageDetailViewModel(images: images,
                                             initialIndex: initialIndex,
                                             favoritesStorage: favoritesStorage)
        
        let viewController = ImageDetailViewController(viewModel: viewModel)
        viewModel.coordinator = coordinator
        return viewController
    }
}
