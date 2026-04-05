//
//  FavoritesScreenConstants.swift
//  GalleryApp
//
//  Created by Dmitry  Divin on 4.04.26.
//

import UIKit

enum FavoritesScreenConstants {
   
    enum Strings {
        static let title = "Favorites"
        static let emptyLabelText: String = "No favorites yet"
    }
    
    enum Colors {
        static let secondaryLabel: UIColor = .secondaryLabel
    }
    
    enum Fonts {
        static let emptyLabelFont: UIFont = .systemFont(ofSize: 18, weight: .regular)
    }
    
    enum Ints {
        static let numberOfColumns: CGFloat = 2
        static let itemHeightRatio: CGFloat = 1.4
    }
    
    enum Layout {
        static let minimumLineSpacing: CGFloat = 10
        static let minimumInteritemSpacing: CGFloat = 10
        static let sectionInset: UIEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        static let padding: CGFloat = 10
        static let trailingConstant: CGFloat = -40
        static let leadingConstant: CGFloat = 40
    }
    
    
}
