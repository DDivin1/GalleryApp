//
//  ImageDetailViewController.swift
//  GalleryApp
//
//  Created by Dmitry  Divin on 25.03.26.
//

import UIKit
import Combine
import Kingfisher

final class ImageDetailViewController: UIViewController {
    
    private let viewModel: ImageDetailViewModel
    private var cancellables: Set<AnyCancellable> = []
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.backgroundColor = ImageDetailsConstants.Colors.systemGray6
        label.layer.cornerRadius = 8
        label.clipsToBounds = true
        label.font = ImageDetailsConstants.Fonts.descriptionFont
        label.numberOfLines = 2
        return label
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .black
        imageView.clipsToBounds = true
        return imageView
    }()
    
    init (viewModel: ImageDetailViewModel) {
        self.viewModel = viewModel
        super.init (nibName: nil, bundle: nil)
    }
    
    required init? (coder: NSCoder) {
        fatalError ("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad () {
        super.viewDidLoad ()
        view.backgroundColor = .red
        title = ImageDetailsConstants.Strings.imageDetailText
        setupUI()
        loadImage()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        imageView.kf.cancelDownloadTask()
    }
    
    private func setupUI () {
        view.addSubview(descriptionLabel)
        view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            descriptionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: view.bottomAnchor, constant: -80),
            descriptionLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            descriptionLabel.heightAnchor.constraint(equalToConstant: 50),
            
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            imageView.widthAnchor.constraint(equalTo: view.widthAnchor),
            imageView.bottomAnchor.constraint(equalTo: descriptionLabel.topAnchor, constant: -20)
        ])
    }
    
    func loadImage() {
        let image = viewModel.currentImage
        
        descriptionLabel.text = image.displayDescription
        
        guard let urlString = image.urls.regularURL,
        let url = URL(string: urlString) else {
            imageView.image = UIImage(systemName: "photo")
            return
        }
        imageView.kf.setImage(
            with: url,
            placeholder: UIImage(systemName: "photo"),
            options: [ .transition(.fade(0.3)), .cacheOriginalImage]
        )
    }
}
