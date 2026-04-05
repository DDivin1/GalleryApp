//
//  ImageCellConstants.swift
//  GalleryApp
//
//  Created by Dmitry  Divin on 5.04.26.
//

import UIKit

final class ImageCellConstants {
    
    enum Strings {
        static let heart: String = "heart"
        static let heartFill: String = "heart.fill"
        static let placeholder: String = "photo"
    }
    
    enum Colors {
        static let systemRed: UIColor = .systemRed
        static let likeButtonBackground: UIColor = UIColor.black.withAlphaComponent(0.4)
    }

    enum Layout {
        static let likeCornerRadius: CGFloat = 16
        static let likeButtonSize: CGFloat = 32
        static let likeButtonTop: CGFloat = 8
        static let likeButtonTrailing: CGFloat = -8
    }
}
