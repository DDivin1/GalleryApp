//
//  FavoritesViewController.swift
//  GalleryApp
//
//  Created by Dmitry  Divin on 25.03.26.
//

import UIKit
import Combine

final class FavoritesViewController: UIViewController {
    
    // MARK: - Properties
    private let viewModel: FavoritesViewModel
    private var collectionView: UICollectionView!
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: - UI Elements
    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    private let emptyLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = FavoritesScreenConstants.Colors.secondaryLabel
        label.font = FavoritesScreenConstants.Fonts.emptyLabelFont
        label.numberOfLines = 0
        label.isHidden = true
        label.text = FavoritesScreenConstants.Strings.emptyLabelText
        return label
    }()
    
    // MARK: - Initialization
    init(viewModel: FavoritesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = FavoritesScreenConstants.Strings.title
        view.backgroundColor = .systemBackground
        setupCollectionView()
        bindViewModel()
        setupEmptyLabel()
        viewModel.loadFavorites()
    }
    
    // MARK: - Setup
    private func setupCollectionView() {
        
        view.addSubview(loadingIndicator)
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = FavoritesScreenConstants.Layout.minimumLineSpacing
        layout.minimumInteritemSpacing = FavoritesScreenConstants.Layout.minimumInteritemSpacing
        layout.sectionInset = FavoritesScreenConstants.Layout.sectionInset
        
        let padding: CGFloat = FavoritesScreenConstants.Layout.padding
        let avalibleWidth = UIScreen.main.bounds.width - (padding * 2) - 10
        let itemWidth = avalibleWidth / FavoritesScreenConstants.Ints.numberOfColumns
        
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth * FavoritesScreenConstants.Ints.itemHeightRatio)
        
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
    
    private func setupEmptyLabel() {
        view.addSubview(emptyLabel)
        emptyLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                                 constant: FavoritesScreenConstants.Layout.trailingConstant),
            emptyLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                                constant: FavoritesScreenConstants.Layout.leadingConstant)
        ])
    }
    
    // MARK: - Binding
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
    
    // MARK: - Actions
    @objc private func imageTapped(_ sender: UITapGestureRecognizer) {
        guard let cell = sender.view as? ImageGalleryCell,
              let indexPath = collectionView.indexPath(for: cell) else {
            return
        }
        viewModel.didSelectImage(at: indexPath.item)
    }
}

// MARK: - UICollectionViewDataSource
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
        
        cell.onFavoriteTapped = { [weak self] in
            guard let self = self else { return }
            
            let imageToRemove = self.viewModel.favoritesImages[indexPath.item]
            self.viewModel.removeFromFavorites(imageID: imageToRemove.id)
        }
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped(_:)))
        cell.addGestureRecognizer(tapGesture)
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension FavoritesViewController: UICollectionViewDelegate {
    
}
