//
//  PresentationController.swift
//  Safe Photo
//
//  Created by Nikolay Chepizhenko on 21.11.2021.
//

import UIKit

class PresentationController: UIPresentationController {

    private weak var transition: HalfScreenTransitionDelegate?

    var popUpHeight: CGFloat = 300
    override var frameOfPresentedViewInContainerView: CGRect {
        return CGRect(x: 0,
                      y: UIScreen.height - popUpHeight,
                      width: UIScreen.width,
                      height: popUpHeight)
    }

    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panned))
        containerView?.addGestureRecognizer(panGesture)
        containerView?.addSubview(presentedView!)
    }

    override func containerViewDidLayoutSubviews() {
        super.containerViewDidLayoutSubviews()
        presentedView?.frame = frameOfPresentedViewInContainerView
    }

    override func presentationTransitionDidEnd(_ completed: Bool) {
        super.presentationTransitionDidEnd(completed)
        print(#function, completed)
        if completed {
            transition?.direction = .dismissing
        }
    }

    override func dismissalTransitionDidEnd(_ completed: Bool) {
        super.dismissalTransitionDidEnd(completed)
        print(#function, completed)
        if completed {
            transition?.direction = .presenting
        }
    }

    @objc
    private func panned(_ gesture: UIPanGestureRecognizer) {

        transition?.sendGesture(gesture)
    }

    required init(transition: HalfScreenTransitionDelegate, presentedViewController: UIViewController, presenting: UIViewController?, popUpSize: CGFloat) {
        self.popUpHeight = popUpSize
        self.transition = transition
        super.init(presentedViewController: presentedViewController, presenting: presenting)
    }
}

final class DimmPresentationController: PresentationController {

    private lazy var dimmView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.7)
        blurView.pin(to: view)
        blurView.alpha = 0
        view.alpha = 0
        return view
    }()

    private lazy var blurView: UIView = {
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.alpha = 1
        return blurEffectView
    }()

    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()
        containerView?.insertSubview(dimmView, at: 0)
        performAlongsideTransitionIfPossible { [unowned self] in
            self.dimmView.alpha = 1
            self.blurView.alpha = 0.7
        }
    }

    private func performAlongsideTransitionIfPossible(_ block: @escaping () -> Void) {
        guard let coordinator = self.presentedViewController.transitionCoordinator else {
            block()
            return
        }

        coordinator.animate(alongsideTransition: { (_) in
            block()
        }, completion: nil)
    }

    override func containerViewDidLayoutSubviews() {
        super.containerViewDidLayoutSubviews()
        dimmView.frame = containerView?.frame ?? .zero
    }

    override func presentationTransitionDidEnd(_ completed: Bool) {
        super.presentationTransitionDidEnd(completed)
        if !completed {
            self.dimmView.removeFromSuperview()
        }
    }

    override func dismissalTransitionWillBegin() {
        super.dismissalTransitionWillBegin()
        performAlongsideTransitionIfPossible { [unowned self] in
            self.dimmView.alpha = 0
            self.blurView.alpha = 0
        }
    }

    override func dismissalTransitionDidEnd(_ completed: Bool) {
        super.dismissalTransitionDidEnd(completed)
        if completed {
            self.dimmView.removeFromSuperview()
        }
    }
}
