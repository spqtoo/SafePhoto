//
//  HalfScreenTransitionDriver.swift
//  Safe Photo
//
//  Created by Nikolay Chepizhenko on 21.11.2021.
//

import UIKit

class HalfScreenTransitionDriver: UIPercentDrivenInteractiveTransition {

    private weak var presentedController: UIViewController?
    private var panRecognizer: UIPanGestureRecognizer?
    private var VCToPresent: UIViewController
    //    private var presentingVC: UIViewController
//    override var completionSpeed: CGFloat {
//        get { return minMax(min: 0.6, current: 1 - percentComplete, max: 0.9) }
//        set {}
//    }
    private var startDismissPoint: CGPoint?

    init(VCToPresent: UIViewController) {
        self.VCToPresent = VCToPresent
        //        self.presentingVC = presentingVC

        super.init()
    }

    var isInteractive = false
    override var wantsInteractiveStart: Bool {
        get { return isInteractive }
        set {}
    }

    private func setInteractive() {
        isInteractive = true
    }

    private func setNotInteractive() {
        startDismissPoint = nil
        isInteractive = false
    }
}

// MARK: - Gesture Handling
extension HalfScreenTransitionDriver {

    func handleVerticalDismiss(recognizer r: UIPanGestureRecognizer) {
        let vel = r.verticalVelocity
        switch r.state {
        case .began:
            startDismissPoint = r.globalLocation
            setInteractive()
            VCToPresent.dismiss(animated: true)
            pause()
//            update(percentComplete)

        case .changed:
            guard let start = startDismissPoint?.y else { return }
            let height = UIScreen.main.bounds.height
            setInteractive()
            let glob = r.globalLocation.y
            let diff = start - glob
            let valueResult = .zero - diff

            let percent = valueResult / height
            let result = minMax(min: 0.001, current: percent, max: 0.999)
            update(result)

            pause()

        case .ended, .cancelled:
            setNotInteractive()
            guard vel < 1000 else {
                finish()
                return
            }
            panEndedDismissal(gesture: r)

        case .failed:
            setNotInteractive()
            cancel()

        default:
            setNotInteractive()
            cancel()
        }
    }

    override func startInteractiveTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        super.startInteractiveTransition(transitionContext)
        guard isInteractive == false else { return }
        finish()
    }
}

