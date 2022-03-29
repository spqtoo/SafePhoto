//
//  UIView+Helpers.swift
//  Image gallery
//
//  Created by Nikolay Chepizhenko on 18.04.2021.
//

import UIKit

extension UIView {

    @discardableResult
    func pin(to view: UIView, margin: CGFloat = 0) -> Self {
        configureIfNeeded(to: view)
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: margin),
            topAnchor.constraint(equalTo: view.topAnchor, constant: margin),
            trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -margin),
            bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -margin)
        ])
        return self
    }

    @discardableResult
    func pinToSafeArea(to view: UIView) -> Self {
        configureIfNeeded(to: view)
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        return self
    }

    private func configureIfNeeded(to view: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        if superview == nil {
            view.addSubview(self)
        }
    }
}

extension UIView {

    @discardableResult
    func pinToSafeArea(to superview: UIView? = nil, anchors: AnchorValues...) -> Self {
        guard let superview = superview ?? self.superview else { fatalErrorIfDebug(); return self }
        configureIfNeeded(to: superview)
        anchors.forEach {
            switch $0 {
            case .left:
                pinToSafeAreaLeft(to: superview)

            case .top:
                pinToSafeAreaTop(to: superview)

            case .right:
                pinToSafeAreaRight(to: superview)

            case .bottom:
                pinToSafeAreaBottom(to: superview)
            }
        }
        return self
    }

    @discardableResult
    func setHeight(value: CGFloat) -> Self {
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: value).isActive = true
        return self
    }

    @discardableResult
    func equalWidth(to superview: UIView? = nil, value: CGFloat = .zero) -> Self {
        guard let superview = superview ?? self.superview else { fatalErrorIfDebug(); return self }
        configureIfNeeded(to: superview)
        widthAnchor.constraint(equalTo: superview.widthAnchor, constant: value).isActive = true
        return self
    }

    @discardableResult
    func setWidth(value: CGFloat) -> Self {
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalToConstant: value).isActive = true
        return self
    }

    @discardableResult
    func widthToHeight() -> Self {
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalTo: heightAnchor).isActive = true
        return self
    }

    @discardableResult
    func heightToWidth() -> Self {
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalTo: widthAnchor).isActive = true
        return self
    }

    @discardableResult
    func pinToSafeAreaTop(to superview: UIView? = nil, constant: CGFloat = .zero) -> Self {
        guard let superview = superview ?? self.superview else { fatalErrorIfDebug(); return self }
        configureIfNeeded(to: superview)
        topAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.topAnchor, constant: constant).isActive = true
        return self
    }

    @discardableResult
    func pinToSafeAreaLeft(to superview: UIView? = nil) -> Self {
        guard let superview = superview ?? self.superview else { fatalErrorIfDebug(); return self }
        configureIfNeeded(to: superview)
        leadingAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.leadingAnchor).isActive = true
        return self
    }

    @discardableResult
    func pinToSafeAreaBottom(to superview: UIView? = nil) -> Self {
        guard let superview = superview ?? self.superview else { fatalErrorIfDebug(); return self }
        configureIfNeeded(to: superview)
        bottomAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.bottomAnchor).isActive = true
        return self
    }

    @discardableResult
    func pinToSafeAreaRight(to superview: UIView? = nil) -> Self {
        guard let superview = superview ?? self.superview else { fatalErrorIfDebug(); return self }
        configureIfNeeded(to: superview)
        trailingAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.trailingAnchor).isActive = true
        return self
    }

    enum AnchorValues: CaseIterable {

        case top
        case left
        case right
        case bottom
    }
}

extension UIView {
    @discardableResult
    func pinToOpposite(to superview: UIView? = nil, anchors: AnchorValues..., constant: CGFloat = .zero) -> Self {
        anchors.forEach {
            switch $0 {
            case .left:
                pinToOppositeLeft(to: superview, constant: constant)

            case .top:
                pinToOppositeTop(to: superview, constant: constant)

            case .right:
                pinToOppositeRight(to: superview, constant: constant)

            case .bottom:
                pinToOppositeBottom(to: superview, constant: constant)
            }
        }
        return self
    }

    @discardableResult
    func pinToOppositeTop(to superview: UIView? = nil, constant: CGFloat = .zero) -> Self {
        guard let superview = superview ?? self.superview else { fatalErrorIfDebug(); return self }
        configureIfNeeded(to: superview)
        topAnchor.constraint(equalTo: superview.bottomAnchor).isActive = true
        return self
    }

    @discardableResult
    func pinToOppositeLeft(to superview: UIView? = nil, constant: CGFloat = .zero) -> Self {
        guard let superview = superview ?? self.superview else { fatalErrorIfDebug(); return self }
        configureIfNeeded(to: superview)
        leadingAnchor.constraint(equalTo: superview.trailingAnchor).isActive = true
        return self
    }

    @discardableResult
    func pinToOppositeBottom(to superview: UIView? = nil, constant: CGFloat = .zero) -> Self {
        guard let superview = superview ?? self.superview else { fatalErrorIfDebug(); return self }
        configureIfNeeded(to: superview)
        bottomAnchor.constraint(equalTo: superview.topAnchor).isActive = true
        return self
    }

    @discardableResult
    func pinToOppositeRight(to superview: UIView? = nil, constant: CGFloat = .zero) -> Self {
        guard let superview = superview ?? self.superview else { fatalErrorIfDebug(); return self }
        configureIfNeeded(to: superview)
        trailingAnchor.constraint(equalTo: superview.leadingAnchor).isActive = true
        return self
    }

    @discardableResult
    func centerHorizontally(to superview: UIView? = nil) -> Self {
        guard let superview = superview ?? self.superview else { fatalErrorIfDebug(); return self }
        configureIfNeeded(to: superview)
        centerXAnchor.constraint(equalTo: superview.centerXAnchor).isActive = true
        return self
    }

    @discardableResult
    func centerVertically(to superview: UIView? = nil) -> Self {
        guard let superview = superview ?? self.superview else { fatalErrorIfDebug(); return self }
        configureIfNeeded(to: superview)
        centerYAnchor.constraint(equalTo: superview.centerYAnchor).isActive = true
        return self
    }
}

// MARK: - ANCHORS LAYOUT

extension UIView {

    // MARK: - Functions

    @discardableResult
    func pinAnchors(to superview: UIView? = nil, anchors: AnchorValues...) -> Self {
        guard let superview = superview ?? self.superview else { fatalErrorIfDebug(); return self }
        configureIfNeeded(to: superview)
        guard !anchors.isEmpty else { fatalErrorIfDebug(); return self }
        anchors.forEach {
            switch $0 {
            case .left:
                pinToLeft(to: superview)

            case .top:
                pinToTop(to: superview)

            case .right:
                pinToRight(to: superview)

            case .bottom:
                pinToBottom(to: superview)
            }
        }
        return self
    }

    @discardableResult
    func pinAnchorsWithConstants(to superview: UIView? = nil, anchors: AnchorValuesAssociated...) -> Self {
        guard let superview = superview ?? self.superview else { fatalErrorIfDebug(); return self }
        configureIfNeeded(to: superview)
        guard !anchors.isEmpty else { fatalErrorIfDebug(); return self }
        anchors.forEach {
            switch $0 {
            case let .left(constant: constant, toView: toView):
                pinToLeft(to: toView ?? superview, constant: constant)

            case let .top(constant: constant, toView: toView):
                pinToTop(to: toView ?? superview, constant: constant)

            case let .right(constant: constant, toView: toView):
                pinToRight(to: toView ?? superview, constant: constant)

            case let .bottom(constant: constant, toView: toView):
                pinToBottom(to: toView ?? superview, constant: constant)
            }
        }
        return self
    }

    @discardableResult
    func pinToTop(to superview: UIView? = nil, constant: CGFloat = .zero) -> Self {
        guard let superview = superview ?? self.superview else { fatalErrorIfDebug(); return self }
        configureIfNeeded(to: superview)
        topAnchor.constraint(equalTo: superview.topAnchor, constant: constant).isActive = true
        return self
    }

    @discardableResult
    func pinToLeft(to superview: UIView? = nil, constant: CGFloat = .zero) -> Self {
        guard let superview = superview ?? self.superview else { fatalErrorIfDebug(); return self }
        configureIfNeeded(to: superview)
        leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: constant).isActive = true
        return self
    }

    @discardableResult
    func pinToBottom(to superview: UIView? = nil, constant: CGFloat = .zero) -> Self {
        guard let superview = superview ?? self.superview else { fatalErrorIfDebug(); return self }
        configureIfNeeded(to: superview)
        bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: constant).isActive = true
        return self
    }

    @discardableResult
    func pinToRight(to superview: UIView? = nil, constant: CGFloat = .zero) -> Self {
        guard let superview = superview ?? self.superview else { fatalErrorIfDebug(); return self }
        configureIfNeeded(to: superview)
        trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: constant).isActive = true
        return self
    }

    enum AnchorValuesAssociated {
//        static var allCases: [UIView.AnchorValues] = [.top(constant: .zero), .left(constant: .zero), .right(constant: .zero), .bottom(constant: .zero)]

        case top(constant: CGFloat, toView: UIView?)
        case left(constant: CGFloat, toView: UIView?)
        case right(constant: CGFloat, toView: UIView?)
        case bottom(constant: CGFloat, toView: UIView?)
    }
}

extension UIView {

    @discardableResult
    func applyBlur(alpha: CGFloat) -> Self {
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.alpha = alpha
        blurEffectView.pin(to: self)
        return self
    }

    @discardableResult
    func darken(alpha: CGFloat) -> Self {
        let darkView = UIView()
        darkView.pin(to: self)
        darkView.backgroundColor = .init(white: .zero, alpha: alpha)
        return self
    }

    @discardableResult
    func applyNeonShadow(radius: CGFloat = 10, alpha: Float = 1, backgroundColor: UIColor? = nil) -> Self {
        guard let backgroundColor = backgroundColor ?? self.backgroundColor else { fatalErrorIfDebug(); return self }
        layer.shadowColor = backgroundColor.cgColor
        layer.shadowOpacity = alpha
        layer.shadowOffset = .zero
        layer.shadowRadius = radius
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
        return self
    }
}

extension UIButton {

    static func getSquaredButton(with size: CGFloat? = nil) -> UIButton {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalTo: button.heightAnchor).isActive = true
        if let size = size { button.heightAnchor.constraint(equalToConstant: size).isActive = true }
        return button
    }

    func withDisabledHighlight() -> Self {
        adjustsImageWhenHighlighted = false
        return self
    }
}

extension UIImageView {

    static func getSquaredImage(with size: CGFloat? = nil, image: UIImage? = nil) -> UIImageView {
        let imageView = UIImageView()
        imageView.image = image
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor).isActive = true
        if let size = size { imageView.heightAnchor.constraint(equalToConstant: size).isActive = true }
        return imageView
    }

    func makeCopy() -> UIImageView {
        let copy = UIImageView()
        copy.frame = frame
        copy.image = image
        copy.contentMode = contentMode
        copy.clipsToBounds = clipsToBounds
        copy.layer.cornerRadius = layer.cornerRadius
        return copy
    }
}

extension UIView {

    var globalFrame: CGRect {
        return convert(frame, to: nil)
    }
}

func fatalErrorIfDebug() {
    #if DEBUG
    fatalError()
    #endif
}

extension UIScreen {
    static var height: CGFloat {
        return UIScreen.main.bounds.height
    }

    static var width: CGFloat {
        return UIScreen.main.bounds.width
    }

    static var maxOrigin: CGPoint {
        return .init(x: width, y: height)
    }

    static var maxXMinYOrigin: CGPoint {
        return .init(x: width, y: .zero)
    }

    static var minusMaxXMinYOrigin: CGPoint {
        return .init(x: -width, y: .zero)
    }

    static var size: CGSize {
        return .init(width: width, height: height)
    }
}

extension Int {
    var isEven: Bool {
        return self % 2 == .zero
    }
}

extension UIView {

    // Using a function since `var image` might conflict with an existing variable
    // (like on `UIImageView`)
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}

extension UIView {

    func iphoneShake() {
        guard isShaking == false else { return }
        removeIphoneShake()
        let animation = CAKeyframeAnimation(keyPath: "transform.rotation.z")
//        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.repeatCount = .infinity
        animation.duration = 0.15
        animation.isRemovedOnCompletion = false
        animation.autoreverses = true
//        animation.
        let radians = CGFloat(0.8).asRadians
        animation.values = [radians, -radians]
        layer.add(animation, forKey: "iphoneShake")
    }

    func removeIphoneShake() {
        layer.removeAnimation(forKey: "iphoneShake")
    }

    var isShaking: Bool { return layer.animation(forKey: "iphoneShake") != nil }
}
