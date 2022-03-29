//
//  Vibro.swift
//  Safe Photo
//
//  Created by Степан Соловьёв on 25.01.2022.
//

import UIKit

func vibroMinimal() { vibro(.minimal) }

func vibro(_ style: VibroStyle) {

//    DispatchQueue.main.async {

        if style == .light || style == .medium || style == .heavy {
            var vibroStyle: UIImpactFeedbackGenerator.FeedbackStyle = .light
            if style == .light { vibroStyle = .light }
            if style == .medium { vibroStyle = .medium }
            if style == .heavy { vibroStyle = .heavy }
            UIImpactFeedbackGenerator(style: vibroStyle).impactOccurred()
        }
        if style == .success || style == .warning || style == .error {
            var vibroStyle: UINotificationFeedbackGenerator.FeedbackType = .success
            if style == .success { vibroStyle = .success }
            if style == .warning { vibroStyle = .warning }
            if style == .error { vibroStyle = .error }
            UINotificationFeedbackGenerator().notificationOccurred(vibroStyle)
        }

        if style == .minimal { UISelectionFeedbackGenerator().selectionChanged() }

//    }
}

enum VibroStyle {
    case light, medium, heavy, success, warning, error, minimal
}
