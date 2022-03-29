//
//  ToolBarStackView.swift
//  Safe Photo
//
//  Created by Степан Соловьёв on 25.01.2022.
//

import UIKit

final class ToolBarStackView: UIView {
    
    private let shareImage: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "square.and.arrow.up")
        view.tintColor = .systemBlue
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let likeImage: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "heart")
        view.tintColor = .systemBlue
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let downloadImage: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "icloud.and.arrow.down")
        view.tintColor = .systemBlue
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let deleteImage: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "trash")
        view.tintColor = .systemBlue
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

//    private let placeholderImageView: UIImageView = {
//        let view = UIImageView(image: placeholderImage)
//        view.contentMode = .scaleAspectFill
//        return view
//    }()

    required init() {
        super.init(frame: .zero)
        configureLayout()
    }

    required init?(coder: NSCoder) {
        super.init(frame: .zero)
        configureLayout()
    }

//    func set(image: UIImage?) {
//        imageView.image = image
//    }
    private func configureStackView() -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: [shareImage, likeImage, downloadImage, deleteImage])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = 40
//        stackView.translatesAutoresizingMaskIntoConstraints = false
//        stackView.heightAnchor.constraint(equalToConstant: 200).isActive = true
//        stackView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.size.width).isActive = true
        return stackView
    }

    private func configureLayout() {
//        backgroundColor = .init(rgb: 0x1B1F27)
//        placeholderImageView.pin(to: self, margin: UIScreen.width / 8)
//        imageView.pin(to: self)
        backgroundColor = ColorManager.tabBarColor
        shareImage.setHeight(value: 15).widthToHeight()
        likeImage.setHeight(value: 15).widthToHeight()
        downloadImage.setHeight(value: 15).widthToHeight()
        deleteImage.setHeight(value: 15).widthToHeight()
        let stackView = configureStackView()
        addSubview(stackView)
        NSLayoutConstraint.activate([
            shareImage.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            
            
            likeImage.leadingAnchor.constraint(equalTo: shareImage.trailingAnchor)
        ])
        shareImage.pinToLeft(to: self, constant: 16)
//        shareImage.pin(to: self)
//        likeImage.pin(to: self)
//        downloadImage.pin(to: self)
//        deleteImage.pin(to: self)
        
    }
    
}
