//
//  FavoritesViewController.swift
//  GalleryApp
//
//  Created by Dmitry  Divin on 25.03.26.
//

import UIKit
import Combine

final class FavoritesViewController: UIViewController {
    
    private let viewModel: FavoritesViewModel
    
    
    init(viewModel: FavoritesViewModel) {
        self.viewModel = viewModel
        super.init (nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Favorites"
        view.backgroundColor = .red
        
    }
    
}
