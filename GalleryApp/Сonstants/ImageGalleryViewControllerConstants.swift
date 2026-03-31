//
//  ImageGalleryViewControllerConstants.swift
//  GalleryApp
//
//  Created by Dmitry  Divin on 26.03.26.
//

import UIKit

enum ImageGalleryViewControllerConstants {
    
    enum Layout {
        
        static let minimumLineSpacing: CGFloat = 10
        static let minimumInteritemSpacing: CGFloat = 10
        static let sectionInset: UIEdgeInsets = .init(top: 10, left: 10, bottom: 10, right: 10)
        static let padding: CGFloat = 10
        static let itemSpacing: CGFloat = 10
        static let bottomContentInset: CGFloat = 80
    }
    
    enum Fonts {
        static let galleryLabelFont: UIFont = .systemFont(ofSize: 24, weight: .bold)
        
    }
    
    enum Strings {
        static let galleryLabelText: String = "Gallery"
        static let emptyLabelText: String = "No images found"
        static let imageDetailText: String = "Image Detail"
        
    }
}
