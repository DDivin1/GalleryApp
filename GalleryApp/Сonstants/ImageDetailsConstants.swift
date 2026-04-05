//
//  ImageDetailsConstants.swift
//  GalleryApp
//
//  Created by Dmitry  Divin on 31.03.26.
//

import UIKit

final class ImageDetailsConstants {
    enum Strings {
        static let imageDetailText: String = "Image Detail".localized
        static let heart: String = "heart"
        static let heartFill: String = "heart.fill"
        static let photo: String = "photo"
    }
    
    enum Ints {
        static let scrollViewHeightRatio = 0.75
        static let descriptionLabelWidthRation = 0.98
        static let pageImageViewWidthRation = 0.98
    }
    
    enum Colors {
        static let systemGray6 = UIColor.systemGray6
        static let red = UIColor.red
        static let likeButtonBackgroundColor = UIColor.black.withAlphaComponent(0.4)
        static let black = UIColor.black
    }
    
    enum Fonts {
        static let descriptionFont = UIFont.systemFont(ofSize: 16)
    }
    
    enum Layout {
        static let descriptionCornerRadius: CGFloat = 8
        static let pageImageViewCorenerRadius: CGFloat = 8
        static let likeButtonCornerRadius: CGFloat = 16
        static let defaultOffset: CGFloat = 16
        static let defaultInset: CGFloat = -16
        static let likeButtonSize: CGFloat = 40
        
    }
}
