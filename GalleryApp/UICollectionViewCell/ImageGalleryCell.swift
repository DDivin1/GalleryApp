//
//  ImageGalleryCell.swift
//  GalleryApp
//
//  Created by Dmitry  Divin on 28.03.26.
//

import UIKit

final class ImageGalleryCell: UICollectionViewCell {
    
    static var identifier: String { "\(Self.self)" }
    
    
    private let imagesImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
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
        
        NSLayoutConstraint.activate([
            imagesImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imagesImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imagesImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imagesImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    func configure(with image: Images) {
        imagesImageView.image = nil
    }
}
