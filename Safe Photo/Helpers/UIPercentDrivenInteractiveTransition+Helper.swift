//
//  UIPercentDrivenInteractiveTransition+Helper.swift
//  Wallpapers
//
//  Created by Nikolay Chepizhenko on 10.07.2021.
//

import UIKit

extension UIPercentDrivenInteractiveTransition {

//    func panEndedPresentingHorizontally(gesture: UIPanGestureRecognizer) {
//        guard gesture.isMoreThanHalfOfScreenHorizontally else {
//            cancel()
//            return
//        }
//        finish()
//    }
//
//    func panEndedDismissalHorizontally(gesture: UIPanGestureRecognizer) {
//        guard gesture.isLessThanHalfOfScreenHorizontally else {
//            cancel()
//            return
//        }
//        finish()
//    }

    @discardableResult
    func panEndedPresenting(gesture: UIPanGestureRecognizer) -> Bool {
        pause()
        guard percentComplete > 0.5 else {
            cancel()
            return false
        }
        finish()
        return true
    }

    @discardableResult
    func panEndedDismissal(gesture: UIPanGestureRecognizer) -> Bool {
        pause()
        guard percentComplete > 0.5 else {
            cancel()
            return false
        }
        finish()
        return true
    }
}
