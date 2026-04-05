//
//  Strings+extencions.swift
//  GalleryApp
//
//  Created by Dmitry  Divin on 5.04.26.
//

import Foundation

extension String {
    
    var localized: String {
        NSLocalizedString(self, comment: "")
    }
}
