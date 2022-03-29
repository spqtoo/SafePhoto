//
//  TabBarItemType.swift
//  Image gallery
//
//  Created by Nikolay Chepizhenko on 17.04.2021.
//

import UIKit

enum TabBarItemType: Int, CaseIterable {
    case albums
//    case passwords
    case settings

    var image: UIImage? {
        switch self {
        case .albums:
            return R.image.add_icon()

//        case .passwords:
//            return R.image.add_icon()

        case .settings:
            return R.image.add_icon()
        }
    }

    var viewController: UINavigationController {
        switch self {
        case .albums:
            return navController(root: AlbumPhotoCollectionViewController())

//        case .passwords:
//            return navController(root: AlbumPhotoCollectionViewController())

        case .settings:
            return navController(root: SettingsViewController())
        }
    }

    private func navController(root: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: root)
        nav.navigationItem.largeTitleDisplayMode = .always
        nav.navigationBar.prefersLargeTitles = true
        return nav
    }
}
