//
//  ImagePlaceholderView.swift
//  Safe Photo
//
//  Created by Nikolay Chepizhenko on 29.11.2021.
//

import UIKit

private let placeholderImage = R.image.image_placeholder()

final class ImagePlaceholderView: UIView {

    private let imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        return view
    }()

    private let placeholderImageView: UIImageView = {
        let view = UIImageView(image: placeholderImage)
        view.contentMode = .scaleAspectFill
        return view
    }()

    required init() {
        super.init(frame: .zero)
        configureLayout()
    }

    required init?(coder: NSCoder) {
        super.init(frame: .zero)
        configureLayout()
    }

    func set(image: UIImage?) {
        imageView.image = image
    }

    private func configureLayout() {
        backgroundColor = .init(rgb: 0x1B1F27)
        placeholderImageView.pin(to: self, margin: UIScreen.width / 8)
        imageView.pin(to: self)
    }
}
