//
//  CustomCellTableView.swift
//  Safe Photo
//
//  Created by Степан Соловьёв on 22.11.2021.
//
import UIKit

class SettingsTableViewBaseCell: UITableViewCell, IdentifiableProtocol {

    fileprivate let titleLabel: UILabel = {
        let title = UILabel()
        title.textColor = .white
        title.font = .boldSystemFont(ofSize: 17)
        title.textAlignment = .left
        return title
    }()

    fileprivate let containerView = UIView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        configureLayout()
    }

    @discardableResult
    func setTitle(_ value: String) -> Self {
        titleLabel.text = value
        return self
    }

    @discardableResult
    func setPosition(as position: CellPositioninSection) -> Self {
        switch position {
        case .top:
            containerView.layer.cornerRadius = 15
            containerView.layer.maskedCorners = [.layerMinXMinYCorner,
                                                    .layerMaxXMinYCorner]

        case .default:
            containerView.layer.cornerRadius = 0

        case .bottom:
            containerView.layer.cornerRadius = 15
            containerView.layer.maskedCorners = [.layerMinXMaxYCorner,
                                                    .layerMaxXMaxYCorner]

        }
        return self
    }

    required init?(coder: NSCoder) {
        super.init(style: .default, reuseIdentifier: Self.identifier)
        configureLayout()
    }

    fileprivate func configureLayout() {
        containerView.pinAnchorsWithConstants(to: contentView, anchors:
                                                    .left(constant: 16, toView: nil),
                                                .right(constant: -16, toView: nil)).pinAnchors(to: nil, anchors: .top, .bottom)

        containerView.backgroundColor = ColorManager.settingsCell

        titleLabel.pinAnchorsWithConstants(to: containerView,
                                           anchors: .left(constant: 32,
                                                          toView: containerView)).centerVertically()

        backgroundColor = .clear
        selectedBackgroundView = .init()
    }

    enum CellPositioninSection {
        case top
        case `default`
        case bottom

        init(itemCount: Int, currentItem: Int) {
            switch currentItem {
            case .zero:
                self = .top

            case itemCount - 1:
                self = .bottom

            default:
                self = .default
            }
        }
    }
}

final class SettingsTableViewTextCell: SettingsTableViewBaseCell {

    private let valueLabel: UILabel = {
        let title = UILabel()
        title.textColor = .white
        title.font = .boldSystemFont(ofSize: 17)
        title.textAlignment = .right
        return title
    }()

    func configure(_ value: String, title: String, position: CellPositioninSection) {
        valueLabel.text = value
        super.setTitle(title)
        super.setPosition(as: position)
    }

    override func configureLayout() {
        super.configureLayout()
        valueLabel.pinAnchorsWithConstants(to: containerView,
                                           anchors: .right(constant: -32,
                                                           toView: containerView)).centerVertically()
    }
}

protocol SettingsTableViewSwitchCellDelegate: AnyObject {

    func switchValueDidChange(value: Bool, id: SettingsViewController.CellModel.ItemContainer.SwitchIdentifier)
}

final class SettingsTableViewSwitchCell: SettingsTableViewBaseCell {

    private lazy var switchView: UISwitch = {
        let switchDemo = UISwitch()
        switchDemo.onTintColor = .init(rgb: 0x656576)
        switchDemo.tintColor = .systemRed
        switchDemo.thumbTintColor = .init(rgb: 0xBDC8F5)
        switchDemo.addTarget(self, action: #selector(switchValueDidChange), for: .valueChanged)

        return switchDemo
    }()

    private var identifier: SettingsViewController.CellModel.ItemContainer.SwitchIdentifier?
    private weak var delegate: SettingsTableViewSwitchCellDelegate?

    func configure(_ value: Bool,
                   id: SettingsViewController.CellModel.ItemContainer.SwitchIdentifier,
                   delegate: SettingsTableViewSwitchCellDelegate,
                   title: String,
                   position: CellPositioninSection) {
        self.identifier = id
        self.delegate = delegate
        switchView.isOn = value
        super.setTitle(title)
        super.setPosition(as: position)
    }

    override func configureLayout() {
        super.configureLayout()
        switchView.pinAnchorsWithConstants(to: containerView,
                                           anchors: .right(constant: -32,
                                                           toView: containerView)).centerVertically()
    }

    @objc
    private func switchValueDidChange() {
        guard let identifier = identifier else {
            fatalErrorIfDebug()
            return
        }

        let switchValue = switchView.isOn

        delegate?.switchValueDidChange(value: switchValue, id: identifier)
    }
}

final class SettingsTableViewImageCell: SettingsTableViewBaseCell {

    private let image: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .init(rgb: 0x656576)
        return imageView
    }()

    func configure(_ value: UIImage?, title: String, position: CellPositioninSection) {
        image.image = value
        super.setTitle(title)
        super.setPosition(as: position)
    }

    override func configureLayout() {
        super.configureLayout()
        image.pinAnchorsWithConstants(to: containerView,
                                           anchors: .right(constant: -32,
                                                           toView: containerView)).centerVertically()
    }
}
