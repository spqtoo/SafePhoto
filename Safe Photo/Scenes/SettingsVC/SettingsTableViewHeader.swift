//
//  CustomHeaderTable.swift
//  Safe Photo
//
//  Created by Степан Соловьёв on 22.11.2021.
//
import UIKit


final class SettingsTableViewHeader: UITableViewHeaderFooterView, IdentifiableProtocol {

    private let titleHeader: UILabel = {
        let title = UILabel()
        title.textColor = .white
        title.font = .systemFont(ofSize: 20, weight: .bold)
        title.textAlignment = .left
        return title
    }()


    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)

        configureContents()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func createContainerForView(titleHead: UILabel) -> UIView {
        let containerView = UIView()
        containerView.layer.cornerRadius = 11
        containerView.backgroundColor = .black
        titleHead.pinAnchorsWithConstants(to: contentView, anchors:
                                            .bottom(constant: -16, toView: nil),
                                            .left(constant: 16, toView: nil))
        return containerView
    }

    private func configureContents() {

        let customHead = createContainerForView(titleHead: titleHeader)

        contentView.addSubview(customHead)

        customHead.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            customHead.topAnchor.constraint(equalTo: contentView.topAnchor),
            customHead.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            customHead.leadingAnchor.constraint(equalTo: contentView.leadingAnchor)
        ])
    }

    func configureSettingTitleHeader(titleForHead: String) {
        titleHeader.text = titleForHead
    }
}
