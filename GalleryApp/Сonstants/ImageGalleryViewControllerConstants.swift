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
        static let errorLabelLeadingConstant: CGFloat = 40
        static let errorLabelTrailingConstant: CGFloat = -40
    }
    
    enum Ints {
        static let numberOfColumns: CGFloat = 2
        static let itemHeightRatio: CGFloat = 1.4
    }
    
    enum Fonts {
        static let galleryLabelFont: UIFont = .systemFont(ofSize: 24, weight: .bold)
        static let emptyLabelFont: UIFont = .systemFont(ofSize: 18)
        static let errorLabelFont: UIFont = .systemFont(ofSize: 16)
    }
    
    enum Colors {
        static let secondaryLabel = UIColor.secondaryLabel
    }
    
    enum Strings {
        static let galleryLabelText: String = "Gallery".localized
        static let emptyLabelText: String = "No images found".localized
        static let favoritesButtonName: String = "star"
    }
}
