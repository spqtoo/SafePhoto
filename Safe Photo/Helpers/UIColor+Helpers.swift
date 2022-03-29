//
//  UIColor+Helpers.swift
//  Image gallery
//
//  Created by Nikolay Chepizhenko on 24.07.2021.
//

import UIKit

extension UIColor {
    public convenience init(rgb: UInt) {
        self.init(
            red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgb & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgb & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }

    public var rgbString: String {
        var red: CGFloat = 0,
            green: CGFloat = 0,
            blue: CGFloat = 0,
            alpha: CGFloat = 0
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return String(format: "#%X%X%X", Int(red * 255), Int(green * 255), Int(blue * 255))
    }
}

extension UIColor {
    func rgb() -> (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat)? {
        var fRed : CGFloat = 0
        var fGreen : CGFloat = 0
        var fBlue : CGFloat = 0
        var fAlpha: CGFloat = 0
        if self.getRed(&fRed, green: &fGreen, blue: &fBlue, alpha: &fAlpha) {
            return (red: fRed, green: fGreen, blue: fBlue, alpha: fAlpha)

        } else {
            return nil
        }
    }

    static func animationColor(from: UIColor, to: UIColor, percent: CGFloat) -> UIColor {
        guard let fromColor = from.rgb() else { return .clear }
        guard let toColor = to.rgb() else { return .clear }
        let redDiff = (toColor.red - fromColor.red) * percent
        let greenDiff = (toColor.green - fromColor.green) * percent
        let blueDiff = (toColor.blue - fromColor.blue) * percent
        let alphaDiff = (toColor.alpha - fromColor.alpha) * percent

        let red = minMax(min: .zero, current:  fromColor.red + redDiff, max: 1)
        let green = minMax(min: .zero, current: fromColor.green + greenDiff, max: 1)
        let blue = minMax(min: .zero, current: fromColor.blue + blueDiff, max: 1)
        let alpha = minMax(min: .zero, current: fromColor.alpha + alphaDiff, max: 1)

        return .init(red: red, green: green, blue: blue, alpha: alpha)
    }
}

extension UIColor {
    static var random: UIColor {
        return .init(red: randomValue, green: randomValue, blue: randomValue, alpha: 1)
    }

    private static var randomValue: CGFloat {
        .random(in: .zero...1)
    }
}
