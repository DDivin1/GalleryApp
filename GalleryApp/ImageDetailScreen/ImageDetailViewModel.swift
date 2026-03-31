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
    
    var currentImage: Images {
        return images[currentImageIndex]
    }
    
    init (images: [Images], initialIndex: Int) {
        self.images = images
        self.currentImageIndex = initialIndex
    }
}
