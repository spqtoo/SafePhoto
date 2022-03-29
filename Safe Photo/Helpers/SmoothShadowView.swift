//
//  SmoothShadowView.swift
//  Image gallery
//
//  Created by Nikolay Chepizhenko on 24.07.2021.
//

import UIKit

private let visibleBlack = UIColor.black.withAlphaComponent(1)
private let hiddenBlack = UIColor.black.withAlphaComponent(.zero)

final class SmoothShadowView: UIView {

    private let direction: Direction
    private let gradient: CAGradientLayer

    init(direction: Direction = .bottomToTop,
         visibleColor: UIColor = visibleBlack,
         hiddenColor: UIColor = hiddenBlack) {

        self.direction = direction
        let colors: [CGColor] = direction.colors(visibleColor: visibleColor.cgColor, hiddenColor: hiddenColor.cgColor)
        gradient = .init(direction: direction, colors: colors)

        super.init(frame: .zero)

        addGradientLayer()
    }

    required init?(coder: NSCoder) {
        direction = .bottomToTop
        gradient = .init(direction: .bottomToTop, colors: [visibleBlack.cgColor, hiddenBlack.cgColor])

        super.init(frame: .zero)

        addGradientLayer()
    }

    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)

        gradient.frame = bounds
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        gradient.frame = bounds
    }

    private func addGradientLayer() {
        layer.insertSublayer(gradient, at: .zero)
        gradient.frame = bounds
    }

    enum Direction {
        case bottomToTop
        case topToBottom
        case leftToRight
        case rightToLeft

        func colors(visibleColor: CGColor, hiddenColor: CGColor) -> [CGColor] {
            switch self {
            case .bottomToTop:
                return [ visibleColor, hiddenColor ]

            case .topToBottom:
                return [ hiddenColor, visibleColor ]

            case .leftToRight:
                return [ hiddenColor, visibleColor ]

            case .rightToLeft:
                return [ visibleColor, hiddenColor ]
            }
        }

        var isVertical: Bool {
            return self == .bottomToTop || self == .topToBottom
        }
    }
}

extension CAGradientLayer {

    private func applyVerticalPoints() {
        startPoint = CGPoint(x: 0.5, y: 1.0)
        endPoint = CGPoint(x: 0.5, y: .zero)
    }

    private func applyHorizontalPoints() {
        startPoint = CGPoint(x: .zero, y: 0.5)
        endPoint = CGPoint(x: 1, y: 0.5)
    }

    private func applyPoints(direction: SmoothShadowView.Direction) {
        guard direction.isVertical else {
            applyHorizontalPoints()
            return
        }
        applyVerticalPoints()
    }

    convenience init(direction: SmoothShadowView.Direction, colors: [CGColor]) {
        self.init()
        applyPoints(direction: direction)
        self.colors = colors
    }
}
