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
    private var cancellables = Set<AnyCancellable>()
    
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
        setupCollectionView()
        setupDataSourceAndDelegate()
        bindViewModel()
        viewModel.loadInitialImages()
    }
    
    private func setupCollectionView() {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = ImageGalleryViewControllerConstants.Layout.minimumLineSpacing
        layout.minimumInteritemSpacing = ImageGalleryViewControllerConstants.Layout.minimumInteritemSpacing
        layout.sectionInset = ImageGalleryViewControllerConstants.Layout.sectionInset
        
        let padding: CGFloat = ImageGalleryViewControllerConstants.Layout.padding
        let interItemSpacing: CGFloat = ImageGalleryViewControllerConstants.Layout.itemSpacing
        let avalibleWidth = UIScreen.main.bounds.width - padding * 2 - interItemSpacing
        let itemWidth = avalibleWidth / 2
        
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth * 1.4)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(ImageGalleryCell.self, forCellWithReuseIdentifier: ImageGalleryCell.identifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .systemBackground
        
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
    }
    
    private func setupDataSourceAndDelegate() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    private func bindViewModel() {
        
        viewModel.$images
        
            .receive(on: DispatchQueue.main)
            .sink { [weak self] images in
                self?.collectionView.reloadData()
            }
            .store(in: &cancellables)
        
        viewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { isLoading in
                print("Loading")
            }
            .store(in: &cancellables)
    }
}



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
        cell.configure(with: image)
        return cell
    }
}

extension ImageGalleryViewController: UICollectionViewDelegateFlowLayout {
    
}
