//
//  HalfScreenPresentAnimation.swift
//  Safe Photo
//
//  Created by Nikolay Chepizhenko on 21.11.2021.
//

import UIKit

class HalfScreenPresentAnimation: NSObject {
    let duration: TimeInterval = 0.3
}

extension HalfScreenPresentAnimation: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let to = transitionContext.view(forKey: .to)!
        let finalFrame = transitionContext.finalFrame(for: transitionContext.viewController(forKey: .to)!) // Тот самый фрейм, который мы задали в PresentationController
        // Смещаем контроллер за границу экрана
        to.frame = finalFrame.offsetBy(dx: 0, dy: finalFrame.height)
        UIView.animate(withDuration: duration, delay: .zero, options: []) {
            to.frame = finalFrame
        } completion: { isSuccessed in
            transitionContext.completeTransition(isSuccessed)
        }
    }
}
