//
//  PinterestNavigationTransitionDriver.swift
//  Safe Photo
//
//  Created by Nikolay Chepizhenko on 23.11.2021.
//

import UIKit

//class PinterestNavigationTransitionDriver: UIPercentDrivenInteractiveTransition {
//
//    private weak var navigationController: PinterestNavigationController?
//
//    required init(navigationController: PinterestNavigationController) {
//        self.navigationController = navigationController
//        super.init()
//    }
//    private var isCancelled = false
//
//    override var completionSpeed: CGFloat {
//        get {
//            if isCancelled == false { return super.completionSpeed }
//            let value = minMax(min: 0.5, current: percentComplete / 1.5, max: 1)
//            print("hehe com", value); return percentComplete }
//        set {}
//    }
//    
//
//    private var isInteractive = false
//    private var startDismissPoint: CGPoint?
//    override var wantsInteractiveStart: Bool {
//        get { return isInteractive }
//        set {}
//    }
//
//    private func setInteractive() {
//        isInteractive = true
//    }
//
//    private func setNotInteractive() {
//        startDismissPoint = nil
//        isInteractive = false
//    }
//}
//
//// MARK: - Gesture Handling
//extension PinterestNavigationTransitionDriver {
//
//    func handleHorizontalDismiss(recognizer r: UIPanGestureRecognizer) {
//        switch r.state {
//        case .began:
//            setInteractive()
//            navigationController?.popViewController(animated: true)
//            startDismissPoint = r.globalLocation
////            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1)) { [weak self] in
//                self.changed(gesture: r)
////            }
////            navigationController?.view.setNeedsLayout()
////            navigationController?.view.layoutIfNeeded()
//
//
//        case .changed:
//            changed(gesture: r)
//
//        case .ended, .cancelled:
//            changed(gesture: r)
//            setNotInteractive()
////            print(r.horizontalVelocity)
//            guard r.horizontalVelocity < 300 else {
//                self.finish()
//                return
//            }
////            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(50)) { [weak self] in
////                guard let self = self else { return }
//
//                print("hehe perc complete", self.percentComplete)
//            if self.percentComplete > 0.3 { self.finish() }
//                else { self.setCancel() }
////            }
////            panEndedDismissal(gesture: r)
//
//        case .failed:
//            setNotInteractive()
//            setCancel()
//
//        default:
//            setNotInteractive()
//            setCancel()
//        }
//    }
//
//    private func changed(gesture: UIPanGestureRecognizer) {
//        guard let start = startDismissPoint?.x else { return }
//        let height = UIScreen.width
//        setInteractive()
//        let glob = gesture.globalLocation.x
//        let diff = start - glob
//        let valueResult = .zero - diff
//
//        let percent = valueResult / height
//        let result = minMax(min: 0.01, current: percent, max: 0.99)
//
//        print("hehe perc", result, gesture.state == .began, gesture.state == .changed, gesture.state == .ended)
//
////        pause()
//        update(result)
//    }
//
//    private func setCancel() {
//        isCancelled = true
//        cancel()
//    }
//
////    override func startInteractiveTransition(_ transitionContext: UIViewControllerContextTransitioning) {
////        super.startInteractiveTransition(transitionContext)
////        guard isInteractive == false else { return }
////        finish()
////    }
//}

