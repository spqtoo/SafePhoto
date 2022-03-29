//
//  PinterestNavigationPresentAnimation.swift
//  Safe Photo
//
//  Created by Nikolay Chepizhenko on 23.11.2021.
//

import UIKit

class PinterestNavigationPresentAnimation: NSObject {
    var duration: TimeInterval {
        isInteractive ? 0.4 : 0.25
    }

    let isInteractive: Bool

    init(_ isInteractive: Bool) {
        self.isInteractive = isInteractive
    }
}

extension PinterestNavigationPresentAnimation: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let fromView = transitionContext.viewController(forKey: .from)!.view!
        let to = transitionContext.viewController(forKey: .to)!.view!
        let fromShadowView = UIView()
        fromShadowView.backgroundColor = .clear
        let toShadowView = UIView()
        toShadowView.backgroundColor = .black

        to.frame = .init(origin: .init(x: UIScreen.width, y: .zero), size: UIScreen.main.bounds.size)
        transitionContext.containerView.addSubview(to)

        if isInteractive {
            fromShadowView.pin(to: fromView)
            toShadowView.pin(to: to)
        }
        UIView.animate(withDuration: duration, delay: .zero, options: .curveEaseInOut) {
            fromView.frame.origin = .init(x: -UIScreen.width, y: .zero)
            to.frame.origin = .zero
            fromShadowView.backgroundColor = .black
            toShadowView.backgroundColor = .clear
        } completion: { isSuccessed in
            let transitionWasCancelled = transitionContext.transitionWasCancelled
//            if transitionWasCancelled { to.removeFromSuperview() }
            fromShadowView.removeFromSuperview()
            toShadowView.removeFromSuperview()
            transitionContext.completeTransition(!transitionWasCancelled)
        }
    }
}
