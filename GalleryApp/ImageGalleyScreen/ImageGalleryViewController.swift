//
//  ImageGalleryViewController.swift
//  GalleryApp
//
//  Created by Dmitry  Divin on 25.03.26.
//

import UIKit
import Combine

final class ImageGalleryViewController: UIViewController {
    
    // MARK: - Properties
    private let viewModel: ImageGalleryViewModel
    private var collectionView: UICollectionView!
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - UI Elements
    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    private let favoritesButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(systemName: ImageGalleryViewControllerConstants.Strings.favoritesButtonName),
                                     style: .plain,
                                     target: nil,
                                     action: nil)
        button.tintColor = .black
        return button
    }()
    
    private let errorLabel: UILabel = {
        let label = UILabel()
        label.textColor = ImageGalleryViewControllerConstants.Colors.secondaryLabel
        label.textAlignment = .center
        label.font = ImageGalleryViewControllerConstants.Fonts.errorLabelFont
        label.numberOfLines = 0
        label.isHidden = true
        return label
    }()
    
    private let emptyLabel: UILabel = {
        let label = UILabel()
        label.text = ImageGalleryViewControllerConstants.Strings.emptyLabelText
        label.textColor = ImageGalleryViewControllerConstants.Colors.secondaryLabel
        label.textAlignment = .center
        label.font = ImageGalleryViewControllerConstants.Fonts.emptyLabelFont
        label.isHidden = true
        return label
    }()
    
    private let footerLoadingView: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    // MARK: - Initialization
    init (viewModel: ImageGalleryViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = ImageGalleryViewControllerConstants.Strings.galleryLabelText
        navigationItem.rightBarButtonItem = favoritesButton
        favoritesButton.target = self
        favoritesButton.action = #selector(favoritesButtonPressed)
        setupCollectionView()
        setupStateViews()
        setupDataSourceAndDelegate()
        setupInfiniteScroll()
        bindViewModel()
        viewModel.loadInitialImages()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.refreshFavoriteState()
        collectionView.reloadData()
    }
    
    // MARK: - Setup
    private func setupCollectionView() {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = ImageGalleryViewControllerConstants.Layout.minimumLineSpacing
        layout.minimumInteritemSpacing = ImageGalleryViewControllerConstants.Layout.minimumInteritemSpacing
        layout.sectionInset = ImageGalleryViewControllerConstants.Layout.sectionInset
        
        let padding: CGFloat = ImageGalleryViewControllerConstants.Layout.padding
        let interItemSpacing: CGFloat = ImageGalleryViewControllerConstants.Layout.itemSpacing
        let avalibleWidth = UIScreen.main.bounds.width - padding * 2 - interItemSpacing
        let itemWidth = avalibleWidth / ImageGalleryViewControllerConstants.Ints.numberOfColumns
        
        layout.itemSize = CGSize(width: itemWidth,
                                 height: itemWidth * ImageGalleryViewControllerConstants.Ints.itemHeightRatio)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(ImageGalleryCell.self, forCellWithReuseIdentifier: ImageGalleryCell.identifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .systemBackground
        
        collectionView.contentInset.bottom = ImageGalleryViewControllerConstants.Layout.bottomContentInset
        
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupStateViews() {
        view.addSubview(loadingIndicator)
        view.addSubview(errorLabel)
        view.addSubview(emptyLabel)
        
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        emptyLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            errorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            errorLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            errorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                                constant: ImageGalleryViewControllerConstants.Layout.errorLabelLeadingConstant),
            errorLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                                 constant: ImageGalleryViewControllerConstants.Layout.errorLabelTrailingConstant),
            
            emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupDataSourceAndDelegate() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    private func setupInfiniteScroll() {
        collectionView.delegate = self
    }
    
    // MARK: - Binding
    private func bindViewModel() {
        
        viewModel.$images
            .receive(on: DispatchQueue.main)
            .sink { [weak self] images in
                self?.collectionView.reloadData()
                self?.updateStateViews(
                    isLoading: false,
                    hasError: false,
                    isEmpty: images.isEmpty
                )
            }
            .store(in: &cancellables)
        
        viewModel.$favoritesIDs
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.collectionView.reloadData()
            }
            .store(in: &cancellables)
        
        viewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                self?.updateStateViews(
                    isLoading: isLoading,
                    hasError: self?.viewModel.errorMessage != nil,
                    isEmpty: self?.viewModel.images.isEmpty ?? true
                )
            }
            .store(in: &cancellables)
        
        viewModel.$isLoadingMore
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoadingMore in
                if isLoadingMore {
                    self?.footerLoadingView.startAnimating()
                } else {
                    self?.footerLoadingView.stopAnimating()
                }
            }
            .store(in: &cancellables)
        
        viewModel.$errorMessage
            .receive(on: DispatchQueue.main)
            .sink { [weak self] errorMessage in
                if let message = errorMessage {
                    self?.errorLabel.text = message
                }
                self?.updateStateViews(isLoading: self?.viewModel.isLoading ?? false,
                                       hasError: errorMessage != nil,
                                       isEmpty: self?.viewModel.images.isEmpty ?? true)
            }
            .store(in: &cancellables)
    }
    
    // MARK: - UI Updates
    private func updateStateViews(isLoading: Bool, hasError: Bool, isEmpty: Bool) {
        if isLoading {
            loadingIndicator.startAnimating()
        } else {
            loadingIndicator.stopAnimating()
        }
        
        loadingIndicator.isHidden = !isLoading
        errorLabel.isHidden = !hasError
        emptyLabel.isHidden = !(isEmpty && !isLoading && !hasError)
        collectionView.isHidden = isLoading || hasError
    }
    
    // MARK: - Actions
    @objc func favoritesButtonPressed() {
        viewModel.showFavorites()
    }
    
    @objc func imageTapped(_ sender: UITapGestureRecognizer) {
        guard let cell = sender.view as? ImageGalleryCell else {
            return
        }
             guard let indexPath = collectionView.indexPath(for: cell) else {
            return
        }
        viewModel.didSelectImage(at: indexPath.item)
    }
}

// MARK: - UICollectionViewDataSource
extension ImageGalleryViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ImageGalleryCell.identifier,
            for: indexPath
        ) as? ImageGalleryCell else {
            return UICollectionViewCell()
        }
        
        let image = viewModel.images[indexPath.item]
        let isFavorite = viewModel.favoritesIDs.contains(image.id)
        
        cell.configure(with: image, isFavorite: isFavorite)
        
        cell.onFavoriteTapped = { [weak self, weak cell] in
            guard let self = self, let cell = cell else { return }
            
            let image = self.viewModel.images[indexPath.item]
            self.viewModel.toggleFavorite(for: image.id)
            
            cell.configure(with: image, isFavorite: self.viewModel.isFavorite(image.id))
        }
        cell.contentView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped(_:)))
        cell.addGestureRecognizer(tapGesture)
        return cell
    }
}

extension ImageGalleryViewController: UICollectionViewDelegateFlowLayout {
    
}

// MARK: - UICollectionViewDelegate
extension ImageGalleryViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let lastItem = viewModel.images.count - 1
        if indexPath.item >= lastItem && !viewModel.isLoadingMore {
            if viewModel.canLoadMoreImages() {
                viewModel.loadMoreImages()
            }
        }
    }
}
