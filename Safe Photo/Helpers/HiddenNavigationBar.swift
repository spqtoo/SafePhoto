//
//  HiddenNavigationBar.swift
//  Image gallery
//
//  Created by Nikolay Chepizhenko on 07.08.2021.
//

import UIKit

final class HiddenNavigationBar: UINavigationController {

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        navigationBar.isTranslucent = true
        view.backgroundColor = UIColor.clear
//        view.backgroundColor = .clear
    }

    func setLargeTitle() -> Self {
        navigationBar.prefersLargeTitles = true
        return self
    }

    func makeHidden() {
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        navigationBar.isTranslucent = true
        view.backgroundColor = UIColor.clear
    }

    func makeVisible() {
        navigationBar.setBackgroundImage(nil, for: .default)
        navigationBar.shadowImage = nil
        navigationBar.isTranslucent = true
        view.backgroundColor = nil
    }
}
