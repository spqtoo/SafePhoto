//
//  SceneDelegate.swift
//  Safe Photo
//
//  Created by Nikolay Chepizhenko on 01.11.2021.
//

import UIKit
import CoreData
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    private lazy var localAuthManager = diContainer.resolve(LocalAuthManagerProtocol.self)!
    private let tabBar = RootTabBarController()
    private let localAuthVC = UIHostingController(rootView: LocalAuthView())
    private let blurView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        return blurEffectView
    }()

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)

        localAuthManager.delegate = self
        localAuthManager.route()

        window?.makeKeyAndVisible()
    }
}

extension SceneDelegate: DISupportable {

    func sceneWillEnterForeground(_ scene: UIScene) {
        localAuthManager.sceneWillEnterForeground()
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        localAuthManager.sceneWillEnterForeground()
    }

    func sceneWillResignActive(_ scene: UIScene) {
        localAuthManager.sceneWillResignActive()
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        localAuthManager.sceneDidEnterBackground()
    }
}

extension SceneDelegate: LocalAuthManagerDelegate {

    func blurWindow() {
        guard let window = window else { return }
        guard blurView.superview == nil else { return }
        blurView.pin(to: window)
    }

    func removeBlur() {
        blurView.removeFromSuperview()
    }

    func showContent() {
        guard !(window?.rootViewController === tabBar) else { return }
        window?.rootViewController = tabBar
    }

    func showLogin() {
        guard !(window?.rootViewController is UIHostingController<LocalAuthView>) else { return }
        window?.rootViewController = localAuthVC
    }
}
