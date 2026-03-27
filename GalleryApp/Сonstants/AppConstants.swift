//
//  AppConstants.swift
//  GalleryApp
//
//  Created by Dmitry  Divin on 26.03.26.
//

import UIKit

enum AppConstants {
    
    static let unsplashAccessKey: String = {
        guard let key = Bundle.main.object(forInfoDictionaryKey: "UnsplashAccessKey") as? String,
              !key.isEmpty else {
            fatalError("Unspash access key is not found")
        }
        return key
    }()
    
    enum Numbers {
        static let numberOfFetchingImages: Int = 30
        static let currentPage: Int = 1
    }
    
    enum Strings {
        static let favoritesKey: String = "favoritesImagesIds"
    }
}
