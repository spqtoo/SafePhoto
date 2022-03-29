//
//  AppDelegate.swift
//  Safe Photo
//
//  Created by Nikolay Chepizhenko on 01.11.2021.
//

import UIKit
import CoreData
import Swinject

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        registerDI()
        UINavigationBar.appearance().tintColor = .white
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {

        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {}
}

private extension AppDelegate {

    private func registerDI() {
        diContainer.register(AlbumsModelProtocol.self) { _ in AlbumsModel() }
        diContainer.register(AlbumViewerModelProtocol.self) { _, arg in
            return AlbumViewerModel(album: arg)
        }
        diContainer.register(ImageViewerVCModelProtocol.self) { _, arg in
            return ImageViewerVCModel(arg)
        }
        diContainer.register(CoreDataProviderProtocol.self) { _ in CoreDataProvider() }.inObjectScope(.container)
        diContainer.register(LocalAuthManagerProtocol.self) { _ in LocalAuthManager() }.inObjectScope(.container)
    }
}

extension AppDelegate: DISupportable {}
