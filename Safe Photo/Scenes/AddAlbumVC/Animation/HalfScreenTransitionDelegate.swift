//
//  HalfScreenTransitionDelegate.swift
//  Safe Photo
//
//  Created by Nikolay Chepizhenko on 21.11.2021.
//

import UIKit

final class HalfScreenTransitionDelegate: NSObject, UIViewControllerTransitioningDelegate {

    private let driver: HalfScreenTransitionDriver
    var direction: Direction = .presenting

    required init(infoVC: UIViewController) {
        driver = .init(VCToPresent: infoVC)
    }

    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        direction = .presenting
        return DimmPresentationController(transition: self,
                                          presentedViewController: presented,
                                          presenting: presenting ?? source,
                                          popUpSize: AddAlbumVC.popUpMinimumHeight)
    }

    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        direction = .dismissing
        return driver
    }

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        direction = .presenting
        return HalfScreenPresentAnimation()
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        direction = .dismissing
        return HalfScreenDismissAnimation()
    }

    func sendGesture(_ g: UIPanGestureRecognizer) {
        driver.handleVerticalDismiss(recognizer: g)
    }
}

enum Direction {
    case presenting
    case dismissing
}
