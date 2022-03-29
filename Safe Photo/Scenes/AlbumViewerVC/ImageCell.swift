//
//  ImageCell.swift
//  Safe Photo
//
//  Created by Nikolay Chepizhenko on 21.11.2021.
//

import UIKit

final class ImageCell: UICollectionViewCell, IdentifiableProtocol {

    // MARK: - Properties

    private(set) lazy var loadingView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
        configureCellUI()
    }

    required init?(coder: NSCoder) {
        super.init(frame: .zero)
        configureLayout()
        configureCellUI()
    }

    //    override func prepareForReuse() {
    //        super.prepareForReuse()
    //        loadingView.clearImage()
    //
    //    }

    // MARK: - Functions

    func configure(with image: UIImage?) {
        loadingView.image = image
    }

    // MARK: - Private functions

    private func configureLayout() {
        contentView.addSubview(loadingView)

        loadingView.pin(to: contentView)
        //        imageView.backgroundColor = ColorsManager.homeBackground
    }

    private func configureCellUI() {
        //        loadingView.pin(to: contentView)
        //        loadingView.backgroundColor = ColorsManager.placeholderColor
        layer.cornerRadius = 15
        loadingView.layer.cornerRadius = layer.cornerRadius
        loadingView.clipsToBounds = true
        contentView.layer.cornerRadius = layer.cornerRadius
        clipsToBounds = true
    }
}
