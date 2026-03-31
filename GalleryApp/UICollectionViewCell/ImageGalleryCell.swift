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
    
    
    private let imagesImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let likeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.setImage(UIImage(systemName: "heart.fill"), for: .selected)
        button.tintColor = .systemRed
        button.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        button.layer.cornerRadius = 16
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
            
            likeButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            likeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            likeButton.widthAnchor.constraint(equalToConstant: 32),
            likeButton.heightAnchor.constraint(equalToConstant: 32)
        ])
        
        likeButton.addTarget(self, action: #selector(likeButtonPressed), for: .touchUpInside)
    }
    
    func configure(with image: Images) {
        imagesImageView.image = nil
        
        imagesImageView.backgroundColor = .systemGray6
        
        guard let thumbURLString = image.urls.thumbURL,
              let url = URL(string: thumbURLString) else {
            return
        }
        imagesImageView.kf.setImage(
            with: url,
            placeholder: UIImage(systemName: "photo"),
            options: [
                .transition(.fade(0.3)),
                .cacheOriginalImage
            ]
        )
    }
    
    @objc private func likeButtonPressed() {
        likeButton.isSelected.toggle()
        print("Like pressed!")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imagesImageView.kf.cancelDownloadTask()
        imagesImageView.image = nil
        likeButton.isSelected = false
    }
}
