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
    private var currentIndex: Int
    private var cancellables: Set<AnyCancellable> = []
    private let contentView: UIView = UIView()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.backgroundColor = ImageDetailsConstants.Colors.systemGray6
        label.layer.cornerRadius = 8
        label.clipsToBounds = true
        label.font = ImageDetailsConstants.Fonts.descriptionFont
        label.numberOfLines = 0
        return label
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .black
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        return imageView
    }()
    
    private let likeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.setImage(UIImage(systemName: "heart.fill"), for: .selected)
        button.tintColor = .systemRed
        button.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        button.layer.cornerRadius = 16
        return button
    }()
    
    init (viewModel: ImageDetailViewModel) {
        self.viewModel = viewModel
        self.currentIndex = viewModel.currentImageIndex
        super.init (nibName: nil, bundle: nil)
    }
    
    required init? (coder: NSCoder) {
        fatalError ("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad () {
        super.viewDidLoad ()
        view.backgroundColor = .systemBackground
        title = ImageDetailsConstants.Strings.imageDetailText
        setupUI()
        bindViewModel()
        loadImage()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        imageView.kf.cancelDownloadTask()
    }
    
    private func setupUI () {
        view.addSubview(descriptionLabel)
        view.addSubview(imageView)
        view.addSubview(likeButton)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            imageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.98),
            imageView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.8),
            
            descriptionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16),
            descriptionLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.98),
            descriptionLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            
            likeButton.topAnchor.constraint(equalTo: imageView.topAnchor, constant: 16),
            likeButton.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: -16),
            likeButton.widthAnchor.constraint(equalToConstant: 40),
            likeButton.heightAnchor.constraint(equalToConstant: 40),
            
        ])
        
        likeButton.addTarget(self, action: #selector(likeButtonPressed), for: .touchUpInside)
    }
    
    private func bindViewModel() {
        
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
    
    @objc private func likeButtonPressed() {
        let currentImage = viewModel.currentImage
        viewModel.toggleFavorite(for: currentImage.id)
        likeButton.isSelected.toggle()
    }
}
