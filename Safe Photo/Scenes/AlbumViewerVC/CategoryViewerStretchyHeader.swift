//
//  CategoryViewerStretchyHeader.swift
//  Image gallery
//
//  Created by Nikolay Chepizhenko on 16.11.2021.
//

import UIKit

protocol CategoryViewerStretchyHeaderDelegate: AnyObject {
    func titleChanged(_ value: String)
}

final class CategoryViewerStretchyHeader: UICollectionReusableView, IdentifiableProtocol {

    private let bgImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleToFill
        view.clipsToBounds = true
//        view.backgroundColor = .systemGreen
        return view
    }()

    private let mainImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()

    private lazy var titleLabel: UITextField = {
        let textField = UITextField()
        textField.placeholder = R.string.localizable.addAlbumTextPlaceholder()
        textField.textColor = .white
        textField.tintColor = .white
//        textField.textAlignment = .center
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        textField.setContentCompressionResistancePriority(.required, for: .vertical)
        textField.font = .systemFont(ofSize: UIScreen.height / 20, weight: .bold)
        textField.adjustsFontSizeToFitWidth = true
        textField.delegate = self
        return textField
    }()

    private let lastUpdateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: UIScreen.height / 75, weight: .light)
        label.textColor = .lightGray
        return label
    }()

    private let countLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: UIScreen.height / 65, weight: .medium)
        label.textColor = .white
        return label
    }()

    private weak var delegate: CategoryViewerStretchyHeaderDelegate?

    func configure(_ model: Model, delegate: CategoryViewerStretchyHeaderDelegate) {
        self.delegate = delegate
        DispatchQueue.main.async { [weak self] in
            self?.mainImageView.image = model.image
            self?.bgImageView.image = model.image
        }
        set(model)
    }

    func update(_ model: Model) {
        UIView.transition(with: mainImageView,
                          duration: 0.4,
                          options: .transitionCrossDissolve,
                          animations: { [weak self] in
            self?.mainImageView.image = model.image
        }, completion: nil)
        UIView.transition(with: bgImageView,
                          duration: 0.4,
                          options: .transitionCrossDissolve,
                          animations: { [weak self] in
            self?.bgImageView.image = model.image
        }, completion: nil)
        set(model)
    }

    private func set(_ model: Model) {
        titleLabel.text = model.name
        countLabel.text = R.string.localizable.albumViewerCountLabel("\(model.itemsCount)")
        titleLabel.isUserInteractionEnabled = model.isEditing
//        lastUpdateLabel.text = R.string.localizable.albumViewerLastUpdate(model.lastUpdate)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        configureLayout()
    }

    required init?(coder: NSCoder) {
        super.init(frame: .zero)

        configureLayout()
    }

    override func updateConstraints() {
        super.updateConstraints()
        updateConst()
    }

    private var lastConstant: CGFloat = .zero

    private func updateConst() {
        let newConstant = frame.height
        guard newConstant != lastConstant else { return }
        lastConstant = newConstant

//        UIView.performWithoutAnimation {
            self.const?.constant = frame.height
//            self.lastConstant = frame.height
//            self.setNeedsLayout()
//            self.layoutIfNeeded()
//            UIView.setAnimationsEnabled(true)
//        }
    }

    @objc
    private func textFieldDidChange() {
        guard let text = titleLabel.text else { return }
        let containsLetters = text.rangeOfCharacter(from: .letters) != nil
        guard containsLetters else { return }
        guard text.isEmpty == false else { return }
        delegate?.titleChanged(text)
    }

    private func configureLayout() {
        bgImageView.pin(to: self)
        bgImageView.applyBlur(alpha: 1)
        mainImageView.pin(to: self)
        clipsToBounds = true
//        backgroundColor = .systemRed
        shadow(visibleColor: AlbumViewerVC.bgColor, hiddenColor: .clear)
        titleLabel.pinAnchorsWithConstants(to: self, anchors: .left(constant: 16, toView: nil), .bottom(constant: -32, toView: nil), .right(constant: -60, toView: nil))
        countLabel.pinAnchorsWithConstants(to: self, anchors: .left(constant: 16, toView: nil))
        countLabel.bottomAnchor.constraint(equalTo: titleLabel.topAnchor).isActive = true
        lastUpdateLabel.pinAnchorsWithConstants(to: self, anchors: .left(constant: .zero, toView: titleLabel))
        lastUpdateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8).isActive = true
    }

    private var const: NSLayoutConstraint?

    private func shadow(visibleColor: UIColor, hiddenColor: UIColor) {
        let shadowView = SmoothShadowView(direction: .bottomToTop, visibleColor: visibleColor, hiddenColor: hiddenColor)
        shadowView.pinAnchors(to: self, anchors: .left, .bottom, .right)//.setHeight(value: VerticalPhotosLayout.minHeaderValue)
        const = shadowView.heightAnchor.constraint(equalToConstant: .zero)
        const?.isActive = true
        shadowView.backgroundColor = .clear
    }

    struct Model {
        let name: String
        let image: UIImage?
        let itemsCount: Int
        let isEditing: Bool
        let lastUpdate: String
    }
}

extension CategoryViewerStretchyHeader: UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""

        // attempt to read the range they are trying to change, or exit if we can't
        guard let stringRange = Range(range, in: currentText) else { return false }

        // add their new text to the existing text
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)

        // make sure the result is under 16 characters
        return updatedText.count >= 1
    }
}

//extension UIImage {
//
//    public enum DataUnits: String {
//        case byte, kilobyte, megabyte, gigabyte
//    }
//
//    func getSizeIn(_ type: DataUnits) -> Double {
//
//        guard let data = self.pngData() else {
//            return .zero
//        }
//
//        var size: Double = 0.0
//
//        switch type {
//        case .byte:
//            size = Double(data.count)
//        case .kilobyte:
//            size = Double(data.count) / 1024
//        case .megabyte:
//            size = Double(data.count) / 1024 / 1024
//        case .gigabyte:
//            size = Double(data.count) / 1024 / 1024 / 1024
//        }
//
//        return size
////        return String(format: "%.2f", size)
//    }
//}

extension UIImage {

    func sizeInMegabytes(compressionQuality: CGFloat) -> Double {
        return jpegData(compressionQuality: compressionQuality)?.megabyte ?? -1
    }
}
extension Data {
    var megabyte: Double {
        return Double(count) / 1024 / 1024
    }
}
