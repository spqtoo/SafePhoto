//
//  PinterestNavigationDismissAnimation.swift
//  Safe Photo
//
//  Created by Nikolay Chepizhenko on 23.11.2021.
//

import UIKit

class PinterestNavigationDismissAnimation: NSObject {
    var duration: TimeInterval {
        isInteractive ? 0.6 : 0.25
    }
    let isInteractive: Bool

    init(_ isInteractive: Bool) {
        self.isInteractive = isInteractive
    }
}

extension PinterestNavigationDismissAnimation: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let finalColor: UIColor = ColorManager.homeScreenBg.withAlphaComponent(0.9)
        let fromView = transitionContext.viewController(forKey: .from)!.view!
        let to = transitionContext.viewController(forKey: .to)!.view!
        let fromShadowView = UIView()
        fromShadowView.backgroundColor = .clear
        let toShadowView = UIView()
        toShadowView.backgroundColor = finalColor

        fromView.frame = .init(x: .zero, y: .zero, width: UIScreen.width, height: UIScreen.height)
        to.frame.origin = UIScreen.minusMaxXMinYOrigin
        transitionContext.containerView.addSubview(to)
        if isInteractive {
            fromShadowView.pin(to: fromView)
            toShadowView.pin(to: to)
        }
        UIView.animate(withDuration: duration, delay: .zero, options: [.curveLinear, .allowUserInteraction]) {
            fromView.frame.origin = UIScreen.maxXMinYOrigin
            to.frame.origin = .zero
            fromShadowView.backgroundColor = finalColor
            toShadowView.backgroundColor = .clear
        } completion: { isSuccessed in
            let transitionWasCancelled = transitionContext.transitionWasCancelled
            if transitionWasCancelled { to.removeFromSuperview() }
            fromShadowView.removeFromSuperview()
            toShadowView.removeFromSuperview()
            transitionContext.completeTransition(!transitionWasCancelled)
        }
    }
}
