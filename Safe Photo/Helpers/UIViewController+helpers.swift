//
//  UIViewController+helpers.swift
//  Safe Photo
//
//  Created by Nikolay Chepizhenko on 27.11.2021.
//

import UIKit

extension UIViewController {

    // MARK: - Properties

    var isModal: Bool {
        let presentingIsModal = presentingViewController != nil
        let presentingIsNavigation = navigationController?.presentingViewController?.presentedViewController == navigationController
        let presentingIsTabBar = tabBarController?.presentingViewController is UITabBarController

        return presentingIsModal || presentingIsNavigation || presentingIsTabBar
    }
}
