//
//  ImageGalleryCell.swift
//  GalleryApp
//
//  Created by Dmitry  Divin on 28.03.26.
//

import UIKit
import Kingfisher

final class ImageGalleryCell: UICollectionViewCell {
    
    static var identifier: String { "\(Self.self)" }
    
    var onFavoriteTapped: (() -> Void)?
    
    private let imagesImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let likeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: ImageCellConstants.Strings.heart), for: .normal)
        button.setImage(UIImage(systemName: ImageCellConstants.Strings.heartFill), for: .selected)
        button.tintColor = ImageCellConstants.Colors.systemRed
        button.backgroundColor = ImageCellConstants.Colors.likeButtonBackground
        button.layer.cornerRadius = ImageCellConstants.Layout.likeCornerRadius
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(imagesImageView)
        contentView.addSubview(likeButton)
        
        imagesImageView.translatesAutoresizingMaskIntoConstraints = false
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imagesImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imagesImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imagesImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imagesImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            likeButton.topAnchor.constraint(equalTo: contentView.topAnchor,
                                            constant: ImageCellConstants.Layout.likeButtonTop),
            likeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                                 constant: ImageCellConstants.Layout.likeButtonTrailing),
            likeButton.widthAnchor.constraint(equalToConstant: ImageCellConstants.Layout.likeButtonSize),
            likeButton.heightAnchor.constraint(equalToConstant: ImageCellConstants.Layout.likeButtonSize)
        ])
        
        likeButton.addTarget(self, action: #selector(likeButtonPressed), for: .touchUpInside)
    }
    
    func configure(with image: Images, isFavorite: Bool) {
        imagesImageView.image = nil
        imagesImageView.backgroundColor = .systemGray6
        
        if let thumbURLString = image.urls.thumbURL, let url = URL(string: thumbURLString) {
            imagesImageView.kf.setImage(
                with: url,
                placeholder: UIImage(systemName: ImageCellConstants.Strings.placeholder),
                options: [.transition(.fade(0.3)), .cacheOriginalImage]
            )
        }
        likeButton.isSelected = isFavorite
    }
    
    @objc private func likeButtonPressed() {
        likeButton.isSelected.toggle()
        onFavoriteTapped?()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imagesImageView.kf.cancelDownloadTask()
        imagesImageView.image = nil
        likeButton.isSelected = false
    }
}
