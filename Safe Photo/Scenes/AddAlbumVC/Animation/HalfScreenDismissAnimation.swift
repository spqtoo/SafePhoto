//
//  HalfScreenDismissAnimation.swift
//  Safe Photo
//
//  Created by Nikolay Chepizhenko on 21.11.2021.
//

import UIKit

class HalfScreenDismissAnimation: NSObject {
    let duration: TimeInterval = 0.3
}

extension HalfScreenDismissAnimation: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let from = transitionContext.view(forKey: .from)!
        let initialFrame = transitionContext.initialFrame(for: transitionContext.viewController(forKey: .from)!)

        UIView.animate(withDuration: duration, delay: .zero, options: []) {
            from.frame = initialFrame.offsetBy(dx: 0, dy: initialFrame.height)

        } completion: { isSuccessed in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}
