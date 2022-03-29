//
//  PinterestNavigationTransitionDelegate.swift
//  Safe Photo
//
//  Created by Nikolay Chepizhenko on 23.11.2021.
//

import UIKit

//class PinterestNavigationController: UINavigationController,
//                                     UIViewControllerTransitioningDelegate,
//                                     UINavigationControllerDelegate {
//
//    private(set) lazy var dismissGesture: UIPanGestureRecognizer = {
//        let gesture = UIPanGestureRecognizer(target: self, action: #selector(didPan))
//        return gesture
//    }()
//    private var transitionDriver: PinterestNavigationTransitionDriver?
//    
//    override var interactivePopGestureRecognizer: UIGestureRecognizer? {
//        get { nil }
//        set {}
//    }
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        delegate = self
//        dismissGesture.delegate = self
//        view.addGestureRecognizer(dismissGesture)
//        setNavigationBarHidden(true, animated: false)
////        extendedLayoutIncludesOpaqueBars = true
//    }
//
//    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
//        return transitionDriver
//    }
//
//    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
//        return transitionDriver
//    }
//
//    func navigationController(_ navigationController: UINavigationController,
//                              animationControllerFor operation: UINavigationController.Operation,
//                              from fromVC: UIViewController,
//                              to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        let isInteractive = transitionDriver != nil
////        guard isInteractive else { return nil }
//        return operation == .pop ? PinterestNavigationDismissAnimation(isInteractive) : PinterestNavigationPresentAnimation(isInteractive)
//    }
//
//    @objc
//    private func didPan(_ gesture: UIScreenEdgePanGestureRecognizer) {
//        let s = gesture.state
//        if gesture.isBeganState { setTransitionDriver() }
//        transitionDriver?.handleHorizontalDismiss(recognizer: gesture)
//        if s != .began && s != .changed { removeTransitionDriver() }
//    }
//
//    private func setTransitionDriver() {
//        transitionDriver = PinterestNavigationTransitionDriver(navigationController: self)
//    }
//
//    private func removeTransitionDriver() {
//        transitionDriver = nil
//    }
//}
//
//extension PinterestNavigationController: UIGestureRecognizerDelegate {
//
//    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
//        guard let pan = gestureRecognizer as? UIPanGestureRecognizer else { return true }
//        return pan.isHorizontalPan
//    }
//}
