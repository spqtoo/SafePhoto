//
//  Colors.swift
//  Safe Photo
//
//  Created by Nikolay Chepizhenko on 22.11.2021.
//

import Foundation
import UIKit

protocol ColorUpdatable {

    func configureColors()
}

final class ColorManager {

    static let shared = ColorManager()

    var theme: UIUserInterfaceStyle {
        return UIScreen.main.traitCollection.userInterfaceStyle
    }

    static var theme: UIUserInterfaceStyle {
        return shared.theme
    }
}

extension ColorManager {
    static var homeScreenBg: UIColor {
        color(light: LightColors.homeScreenBg, dark: DarkColors.homeScreenBg)
    }
    
    static var settingsCell: UIColor {
        color(light: LightColors.settingsCell, dark: DarkColors.settingsCell)
    }
    
    static var addButtonBlue: UIColor {
        color(light: LightColors.addButtonBlue, dark: DarkColors.addButtonBlue)
    }
    
    static var addButtonRed: UIColor {
        color(light: LightColors.addButtonRed, dark: DarkColors.addButtonRed)
    }
    
    static var tabBarColor: UIColor {
        color(light: LightColors.tabBarColor, dark: DarkColors.tabBarColor)
    }
    
    static var highlightBgColor: UIColor {
        color(light: LightColors.highlightBgColor, dark: DarkColors.highlightBgColor)
    }
    
    static var primaryColor: UIColor {
        color(light: LightColors.primaryColor, dark: DarkColors.primaryColor)
    }

    static func color(light: UIColor, dark: UIColor) -> UIColor {
        switch theme {
        case .dark:
            return dark

        case .light, .unspecified:
            return light

        @unknown default:
            return light
        }
    }
}

enum LightColors {

    static let homeScreenBg: UIColor = .black
    static let settingsCell: UIColor = .systemOrange
    static let addButtonBlue: UIColor = .green
    static let addButtonRed: UIColor = .blue
    static let tabBarColor: UIColor = .purple
    static let highlightBgColor: UIColor = .systemYellow
    static let primaryColor: UIColor = .black
}

enum DarkColors {
    
    static let homeScreenBg: UIColor = .init(rgb: 0x0F1115)
    static let settingsCell: UIColor = .init(rgb: 0x2A2E36)
    static let addButtonBlue: UIColor = .init(rgb: 0x4E6187)
    static let addButtonRed: UIColor = .init(rgb: 0xC96060)
    static let tabBarColor: UIColor = .init(rgb: 0x1D2026)
    static let highlightBgColor: UIColor = .init(rgb: 0x7B7B7B)
    static let primaryColor: UIColor = .white
}
