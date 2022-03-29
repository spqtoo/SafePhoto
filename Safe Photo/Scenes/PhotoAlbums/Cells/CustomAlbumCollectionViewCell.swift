//
//  CustomAlbumCollectionViewCell.swift
//  Safe Photo
//
//  Created by Степан Соловьёв on 02.11.2021.
//

import UIKit

final class CustomAlbumCollectionViewCell: UICollectionViewCell,
                                           IdentifiableProtocol {

    private let checkBoxBackground: UIView = {
        let label = UIView()
        label.backgroundColor = .white
        label.layer.cornerRadius = 15
        label.alpha = .zero
        return label
    }()

    private let labelUnderPictureForAlbum: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .left
//        label.font = UIFont(resource: R., size: 12)
        label.font = .systemFont(ofSize: 16)
        return label
    }()

    private let checkImage: UIImageView = {
        let imageView = UIImageView(image: R.image.checkElement())
        imageView.alpha = .zero
        imageView.tintColor = .black
        return imageView
    }()

    private let albumImage: ImagePlaceholderView = {
        let imageView = ImagePlaceholderView()
//        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        let containView = createContainerForView(nameOfAlbum: labelUnderPictureForAlbum)

        contentView.addSubview(albumImage)
//        contentView.addSubview(containView)
        addSubview(checkBoxBackground)
        addSubview(labelUnderPictureForAlbum)
        albumImage.clipsToBounds = false
        albumImage.layer.masksToBounds = true
        contentView.layer.cornerRadius = 16
        contentView.clipsToBounds = false
        contentView.layer.masksToBounds = true
        
        labelUnderPictureForAlbum.translatesAutoresizingMaskIntoConstraints = false
        checkBoxBackground.translatesAutoresizingMaskIntoConstraints = false
        checkElementAll()

        NSLayoutConstraint.activate(([
//            containView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
//            containView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
//            containView.heightAnchor.constraint(equalToConstant: 40),
//            containView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
//            containView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            checkBoxBackground.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                                        constant: -5),
            checkBoxBackground.topAnchor.constraint(equalTo: contentView.topAnchor,
                                                    constant: -5),
            checkBoxBackground.widthAnchor.constraint(equalToConstant: 30),

            checkBoxBackground.heightAnchor.constraint(equalToConstant: 30),

            albumImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            albumImage.topAnchor.constraint(equalTo: contentView.topAnchor),
            albumImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            albumImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            labelUnderPictureForAlbum.leadingAnchor.constraint(equalTo: albumImage.leadingAnchor),
            labelUnderPictureForAlbum.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,
                                              constant: 32),
//            labelUnderPictureForAlbum.topAnchor.constraint(equalTo: containerView.topAnchor,
//                                           constant: 5),
            labelUnderPictureForAlbum.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                                constant: -16),
            labelUnderPictureForAlbum.widthAnchor.constraint(equalTo: labelUnderPictureForAlbum.widthAnchor)
        ]))
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        labelUnderPictureForAlbum.text = nil
    }

    private func checkElementAll(){
        checkBoxBackground.addSubview(checkImage)
        checkImage.translatesAutoresizingMaskIntoConstraints = false

        checkImage.alpha = .zero

        NSLayoutConstraint.activate(([

            checkImage.centerYAnchor.constraint(equalTo: checkBoxBackground.centerYAnchor),
            checkImage.centerXAnchor.constraint(equalTo: checkBoxBackground.centerXAnchor),
            checkImage.widthAnchor.constraint(equalToConstant: 12),
            checkImage.heightAnchor.constraint(equalToConstant: 12)

        ]))

    }

    func configure(_ model: Model) {
        labelUnderPictureForAlbum.text = model.album.albumName
        albumImage.set(image: model.album.image)
        update(model.selectingModel)
    }

    func update(_ selectedModel: SelectingModel) {
        if selectedModel.isSelecting { iphoneShake() }
        else { removeIphoneShake() }
        configureIsHiddenCheckElement(selectedModel.isSelected)
        configureIsHiddenCheckBackground(isSelecting: selectedModel.isSelecting, isSelected: selectedModel.isSelected)
    }

    private func configureIsHiddenCheckBackground(isSelecting: Bool, isSelected: Bool) {
        UIView.animate(withDuration: 0.3) { [weak self] in
            let ifSelectedValue: CGFloat = isSelected ? 1 : 0.5
            let value: CGFloat = isSelecting ? ifSelectedValue : .zero
            self?.checkBoxBackground.alpha = value
        }
    }

    private func configureIsHiddenCheckElement(_ value: Bool) {
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.checkImage.alpha = value ? 1 : .zero
        }
        
    }
    
    private func createContainerForView(nameOfAlbum: UILabel) -> UIView {
        let containerView = UIView()
//        containerView.layer.cornerRadius = 11
        containerView.backgroundColor = .clear

        containerView.addSubview(nameOfAlbum)

        nameOfAlbum.translatesAutoresizingMaskIntoConstraints = false
        containerView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate(([

            nameOfAlbum.leadingAnchor.constraint(equalTo: containerView.leadingAnchor,
                                               constant: 16),
            nameOfAlbum.bottomAnchor.constraint(equalTo: containerView.bottomAnchor,
                                              constant: -5),
            nameOfAlbum.topAnchor.constraint(equalTo: containerView.topAnchor,
                                           constant: 5),
            nameOfAlbum.trailingAnchor.constraint(equalTo: containerView.trailingAnchor,
                                                constant: -16),
            nameOfAlbum.widthAnchor.constraint(equalTo: nameOfAlbum.widthAnchor),


        ]))
        
        return containerView
    }
}

extension CustomAlbumCollectionViewCell {

    struct Model {
        let album: Album
        let selectingModel: SelectingModel
    }

    struct SelectingModel {
        let isSelecting: Bool
        let isSelected: Bool
    }
}
