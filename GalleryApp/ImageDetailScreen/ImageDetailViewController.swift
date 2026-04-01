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
    private var didSetupPages = false
    
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
        scrollToCurrentPage()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        guard !didSetupPages else { return }
        didSetupPages = true
        setupPages()
        scrollToCurrentPage()
    }
    
    private func setupUI () {
        view.addSubview(scrollView)
        view.addSubview(descriptionLabel)
        view.addSubview(likeButton)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.75),
            
            descriptionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 16),
            descriptionLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.98),
            descriptionLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            
            likeButton.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16),
            likeButton.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            likeButton.widthAnchor.constraint(equalToConstant: 40),
            likeButton.heightAnchor.constraint(equalToConstant: 40),
            
        ])
        likeButton.addTarget(self, action: #selector(likeButtonPressed), for: .touchUpInside)
        scrollView.delegate = self
    }
    
    private func setupPages() {
        let pageWidth = view.bounds.width
        let pageHeight = scrollView.bounds.height
        
        guard pageHeight > 0, pageWidth > 0 else { return }
        
        for (index, image) in viewModel.images.enumerated() {
            let containerView = UIView()
            containerView.translatesAutoresizingMaskIntoConstraints = false
            scrollView.addSubview(containerView)
            
            NSLayoutConstraint.activate([
                containerView.topAnchor.constraint(equalTo: scrollView.topAnchor),
                containerView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: CGFloat(index) * pageWidth),
                containerView.widthAnchor.constraint(equalToConstant: pageWidth),
                containerView.heightAnchor.constraint(equalToConstant: pageHeight)
            ])
        
            let pageImageView = UIImageView()
            pageImageView.contentMode = .scaleAspectFill
            pageImageView.clipsToBounds = true
            pageImageView.backgroundColor = .black
            pageImageView.translatesAutoresizingMaskIntoConstraints = false
            pageImageView.layer.cornerRadius = 8
            
            scrollView.addSubview(pageImageView)
            
            NSLayoutConstraint.activate([
                pageImageView.topAnchor.constraint(equalTo: containerView.topAnchor),
                pageImageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
                pageImageView.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.98),
                pageImageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
            ])
            
            if let urlString = image.urls.regularURL, let url = URL(string: urlString) {
                pageImageView.kf.setImage(
                    with: url,
                    placeholder: UIImage(systemName: "photo"),
                    options: [.transition(.fade(0.3)), .cacheOriginalImage]
                )
            } else {
                pageImageView.image = UIImage(systemName: "photo")
            }
        }
        
        scrollView.contentSize = CGSize(width: pageWidth * CGFloat(viewModel.images.count), height: pageHeight)
        scrollView.contentSize.height = pageHeight
    }
    
    private func scrollToCurrentPage() {
        let pageWidth = view.bounds.width
        let offsetX = CGFloat(viewModel.currentImageIndex) * pageWidth
        scrollView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: false)
    }
    
    private func bindViewModel() {
        viewModel.$currentImageIndex
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.updateUI()
            }
            .store(in: &cancellables)
        
        viewModel.$favoritesIDs
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.updateLikeButton()
            }
            .store(in: &cancellables)
    }
    
    private func updateUI() {
        let image = viewModel.currentImage
        descriptionLabel.text = image.displayDescription
        updateLikeButton()
    }
    
    private func updateLikeButton() {
        let image = viewModel.currentImage
        likeButton.isSelected = viewModel.isFavorite(for: image.id)
    }
    
    @objc private func likeButtonPressed() {
        let currentImage = viewModel.currentImage
        viewModel.toggleFavorite(for: currentImage.id)
        likeButton.isSelected.toggle()
    }
}


extension ImageDetailViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageWidth = scrollView.bounds.width
        let newIndex = Int(scrollView.contentOffset.x / pageWidth)
        guard newIndex != viewModel.currentImageIndex else { return }
        viewModel.setCurrentImageIndex(newIndex)
    }
}
