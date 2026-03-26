//
//  ImageGalleryViewController.swift
//  GalleryApp
//
//  Created by Dmitry  Divin on 25.03.26.
//

import UIKit
import Combine

final class ImageGalleryViewController: UIViewController {
    
    private let viewModel: ImageGalleryViewModel
    private var collectionView: UICollectionView!
    
    
    init (viewModel: ImageGalleryViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = ImageGalleryViewControllerConstants.Strings.galleryLabelText
        
    }
}
