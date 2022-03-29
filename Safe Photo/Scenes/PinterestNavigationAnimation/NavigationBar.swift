//
//  NavigationBar.swift
//  Safe Photo
//
//  Created by Nikolay Chepizhenko on 26.11.2021.
//

import UIKit

protocol NavigationBarFrameDelegate: AnyObject {

    func frameDidChange()
    func boundsDidChange()
}

final class NavigationBar: UINavigationBar {

    private weak var frameDelegate: NavigationBarFrameDelegate?

    override var frame: CGRect {
        didSet {
            guard frame != oldValue else { return }
            frameDelegate?.frameDidChange()
        }
    }

    override var bounds: CGRect {
        didSet {
            guard bounds != oldValue else { return }
            frameDelegate?.boundsDidChange()
        }
    }

    required init(_ delegate: NavigationBarFrameDelegate) {
        super.init(frame: .zero)
        self.frameDelegate = delegate
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

final class CustomNavBar: UIView {

    private let leftView = UIView()
    private let midView = UIView()
    private let rightView = UIView()

    private lazy var navBarHeightConstraint = heightAnchor.constraint(equalToConstant: 44)

    private lazy var leftViewHeightToWidthConstraint = leftView.heightAnchor.constraint(equalTo: leftView.widthAnchor)
    private lazy var rightViewHeightToWidthConstraint = rightView.heightAnchor.constraint(equalTo: rightView.widthAnchor)

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
    }

    required init?(coder: NSCoder) {
        super.init(frame: .zero)
        configureLayout()
    }

    func set(view: UIView, to type: ViewType, shouldWidthEqualsHeight: Bool) {
        let barView = getView(for: type)
        barView.subviews.forEach { $0.removeFromSuperview() }
        setWidthToHeight(for: type, isActive: shouldWidthEqualsHeight)
        view.pin(to: barView)
    }

    func setTitle(height: CGFloat) {
        guard navBarHeightConstraint.constant - 44 != height else { return }
        navBarHeightConstraint.constant = 44 + height + 16 // 16 отступ снизу для заголовка
    }

    func removeNavBarView(type: CustomNavBar.ViewType) {
        getView(for: type).subviews.forEach { $0.removeFromSuperview() }
    }

    private func getView(for type: ViewType) -> UIView {
        switch type {
        case .left:
            return leftView

        case .center:
            return midView

        case .right:
            return rightView
        }
    }

    private func setWidthToHeight(for type: ViewType, isActive: Bool) {
        switch type {
        case .left:
            leftViewHeightToWidthConstraint.isActive = isActive

        case .center:
            fatalErrorIfDebug()

        case .right:
            rightViewHeightToWidthConstraint.isActive = isActive
        }
    }

    private func configureLayout() {
        leftView.pinAnchors(to: self, anchors: .top).setHeight(value: 44).pinAnchorsWithConstants(to: nil, anchors: .left(constant: 16, toView: nil))
        rightView.pinAnchors(to: self, anchors: .top).setHeight(value: 44).pinAnchorsWithConstants(to: nil, anchors: .right(constant: -16, toView: nil))
        midView.pinAnchors(to: self, anchors: .top).setHeight(value: 44)
        NSLayoutConstraint.activate([
            midView.leadingAnchor.constraint(equalTo: leftView.trailingAnchor, constant: 16),
            midView.trailingAnchor.constraint(equalTo: rightView.leadingAnchor, constant: -16),
//            largeTitle.topAnchor.constraint(equalTo: leftView.bottomAnchor, constant: 16),
            navBarHeightConstraint
        ])
    }

    enum ViewType {
        case left
        case center
        case right
    }
}

class CustomNavBarViewController: UIViewController {

    private(set) lazy var navBar = CustomNavBar()
    fileprivate let largeTitle = UILabel()
    private lazy var navBarTopConstraint = navBar.topAnchor.constraint(equalTo: view.topAnchor)
    private var maxSafeAreaTop: CGFloat = .zero {
        didSet {
            guard oldValue != maxSafeAreaTop else { return }
            navBarTopConstraint.constant = (maxSafeAreaTop - additionalSafeAreaInsets.top)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureLayout()
//        navBar.setItems([.init(title: "ITEM 1"), .init(title: "ITEM 2")], animated: true)
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        updateInsets()
    }

    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
        updateInsets()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateInsets()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        view.bringSubviewToFront(navBar)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        view.bringSubviewToFront(navBar)
    }

    func updateInsets() {
//        navBar.sizeToFit()
//        view.setNeedsLayout()
//        view.layoutIfNeeded()

        additionalSafeAreaInsets.top = navBar.frame.height
        maxSafeAreaTop = max(view.safeAreaInsets.top, maxSafeAreaTop)
    }

    func configureLayout() {
        navBar.pinAnchors(to: view, anchors: .left, .right)
        NSLayoutConstraint.activate([
            navBarTopConstraint
        ])

        largeTitle.pinAnchorsWithConstants(to: view, anchors: .left(constant: 16, toView: nil))
        largeTitle.topAnchor.constraint(equalTo: navBar.topAnchor, constant: 44).isActive = true
    }
}

class AutomaticBackButtonViewController: CustomNavBarViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func setBackButtonAutomatically() {
        if isModal {
            setCloseButton()
        }
        else {
            setBackButton()
        }
    }

    @objc
    func backButtonDidPress() {
        navigationController!.popViewController(animated: true)
    }

    func setNavBarItem(view: UIView, shouldWidthEqualsHeight: Bool = false, for type: CustomNavBar.ViewType) {
        navBar.set(view: view, to: type, shouldWidthEqualsHeight: shouldWidthEqualsHeight)
    }

    func setBackButton() {
        navBar.set(view: createImageView(R.image.back_icon(),
                                         target: self,
                                         selector: #selector(backButtonDidPress),
                                         type: .left),
                   to: .left,
                   shouldWidthEqualsHeight: true)
    }

    func setCloseButton() {
        navBar.set(view: createImageView(R.image.dismiss_icon(),
                                         target: self,
                                         selector: #selector(backButtonDidPress),
                                         type: .left),
                   to: .left, shouldWidthEqualsHeight: true)
    }

    func setImageViewToNavBar(_ image: UIImage?,
                              margin: CGFloat,
                              target: Any,
                              selector: Selector,
                              shouldWidthEqualsHeight: Bool,
                              for type: CustomNavBar.ViewType) {
        
        navBar.set(view: createImageView(image,
                                         margin: margin,
                                         target: target,
                                         selector: selector,
                                         type: type),
                   to: type,
                   shouldWidthEqualsHeight: shouldWidthEqualsHeight)
    }

    func removeNavBarView(type: CustomNavBar.ViewType) {
        navBar.removeNavBarView(type: type)
    }

    func setLargeTitle(_ string: String, font: UIFont? = .boldSystemFont(ofSize: UIScreen.width / 10)) {
        largeTitle.text = string
        largeTitle.font = font
        largeTitle.sizeToFit()
        navBar.setTitle(height: largeTitle.intrinsicContentSize.height)
        updateInsets()
    }

    func createImageView(_ image: UIImage?, margin: CGFloat = 8, target: Any, selector: Selector, type: CustomNavBar.ViewType) -> UIView {
        let view = UIImageView(image: image)
        view.contentMode = .scaleAspectFit
        let container = UIView()
        container.isUserInteractionEnabled = true
        container.addGestureRecognizer(UITapGestureRecognizer(target: target, action: selector))
        view.pinAnchorsWithConstants(to: container, anchors: .top(constant: margin, toView: nil), .bottom(constant: -margin, toView: nil))
        switch type {
        case .left:
            view.pinAnchors(to: container, anchors: .left)
            view.pinAnchorsWithConstants(to: container, anchors: .right(constant: margin * -2, toView: nil))

        case .right:
            view.pinAnchors(to: container, anchors: .right)
            view.pinAnchorsWithConstants(to: container, anchors: .left(constant: margin * 2, toView: nil))

        case .center:
            view.centerHorizontally()
        }
        return container
    }
}

extension CustomNavBarViewController: NavigationBarFrameDelegate {

    func frameDidChange() {
        updateInsets()
    }

    func boundsDidChange() {
        updateInsets()
    }
}
