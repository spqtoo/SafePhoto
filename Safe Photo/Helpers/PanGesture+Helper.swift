//
//  PanGesture+Helper.swift
//  Wallpapers
//
//  Created by Nikolay Chepizhenko on 10.07.2021.
//

import UIKit

extension UIPanGestureRecognizer {

    var isBeganState: Bool {
        state == .began || state == .possible
    }

    var globalLocation: CGPoint {
        location(in: nil)
    }

    var globalLocationPercentHorizontally: CGFloat {
        globalLocation.x * 100 / UIScreen.main.bounds.width
    }

    var globalLocationPercentVertically: CGFloat {
        globalLocation.y * 100 / UIScreen.main.bounds.height
    }

    var isMoreThanHalfOfScreenHorizontally: Bool {
        return globalLocationPercentHorizontally > 50.0
    }

    var isLessThanHalfOfScreenHorizontally: Bool {
        return globalLocationPercentHorizontally < 50.0
    }

    var isMoreThanHalfOfScreenVertically: Bool {
        return globalLocationPercentVertically > 50.0
    }

    var isLessThanHalfOfScreenVertically: Bool {
        return globalLocationPercentVertically < 50.0
    }

    var isHorizontalPan: Bool {
        return verticalVelocity < horizontalVelocity
    }

    // MARK: Velocity

    var horizontalVelocity: CGFloat {
        velocity(in: nil).x
    }

    var verticalVelocity: CGFloat {
        velocity(in: nil).y
    }

    func isHorizontalSwipe(requiredVelocity: CGFloat) -> Bool {
        return isBeganState ? false : horizontalVelocity > requiredVelocity
    }

    func disable() {
        isEnabled = false
        isEnabled = true
    }
}
