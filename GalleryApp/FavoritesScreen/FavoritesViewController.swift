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
    private var collectionView: UICollectionView!
    private var cancellables: Set<AnyCancellable> = []
    
    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    private let emptyLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.numberOfLines = 0
        label.isHidden = true
        label.text = "No favorites yet"
        return label
    }()
    
    
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
        view.backgroundColor = .systemBackground
        setupCollectionView()
        bindViewModel()
        setupEmptyLabel()
        viewModel.loadFavorites()
        }
    
    private func setupCollectionView() {
        
        view.addSubview(loadingIndicator)
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        let padding: CGFloat = 10
        let avalibleWidth = UIScreen.main.bounds.width - (padding * 2) - 10
        let itemWidth = avalibleWidth / 2
        
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth * 1.4)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(ImageGalleryCell.self, forCellWithReuseIdentifier: ImageGalleryCell.identifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    private func bindViewModel() {
        viewModel.$favoritesImages
            .receive(on: DispatchQueue.main)
            .sink { [weak self] images in
                self?.collectionView.reloadData()
                self?.emptyLabel.isHidden = !images.isEmpty
            }
            .store(in: &cancellables)
        
        viewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                if isLoading {
                    self?.loadingIndicator.startAnimating()
                } else {
                    self?.loadingIndicator.stopAnimating()
                }
            }
            .store(in: &cancellables)
    }
    
    private func setupEmptyLabel() {
        view.addSubview(emptyLabel)
        emptyLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            emptyLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40)
        ])
    }
}

extension FavoritesViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.favoritesImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ImageGalleryCell.identifier,
            for: indexPath
        ) as? ImageGalleryCell else {
            return UICollectionViewCell()
        }
        
        let image = viewModel.favoritesImages[indexPath.item]
        let isFavorite = true
        
        cell.configure(with: image, isFavorite: isFavorite)
        
        cell.onFavoriteTapped = { [weak self, weak cell] in
            guard let self = self, let cell = cell else { return }
            
            let imageToRemove = self.viewModel.favoritesImages[indexPath.item]
            self.viewModel.removeFromFavorites(imageID: imageToRemove.id)
        }
        
        return cell
    }
}

extension FavoritesViewController: UICollectionViewDelegate {
}
