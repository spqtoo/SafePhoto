//
//  TabBarItem.swift
//  Image gallery
//
//  Created by Nikolay Chepizhenko on 17.04.2021.
//

//import UIKit
//
//final class TabBarItem {
//
//    let viewController: UIViewController
//    let type: TabBarItemType
//    var state: TabBarItemState {
//        didSet {
//            reloadImageColor()
//        }
//    }
//    let button: UIButton = {
//        let button = UIButton()
//        button.setHeight(value: 25).heightToWidth()
//        button.isUserInteractionEnabled = false
//        //        button.translatesAutoresizingMaskIntoConstraints = false
//        //        button.heightAnchor.constraint(equalToConstant: 10).isActive = true
//        //        button.widthAnchor.constraint(equalTo: button.heightAnchor).isActive = true
//        return button
//    }()
//    lazy var buttonContainer: UIView = {
//        let view = UIView()
//        button.centerVertically(to: view).centerHorizontally()
//        return view
//    }()
//
//    private let function: (TabBarItemType) -> Void
//
//    init(type: TabBarItemType, function: @escaping (TabBarItemType) -> Void) {
//        self.type = type
//        state = .inactive
//        viewController = type.viewController
//        self.function = function
//        configureButton()
////        configureButton(target: target, selector: selector)
//        reloadImageColor()
//    }
//
//    // MARK: - Private functions
//
//    private func configureButton() {
//        button.setImage(type.image, for: .normal)
//        buttonContainer.isUserInteractionEnabled = true
//        buttonContainer.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapped)))
////        button.addTarget(self, action: #selector(tapped), for: .touchUpInside)
////        button.tag = type.rawValue
//        buttonContainer.tag = type.rawValue
//    }
//
//    @objc
//    private func tapped() {
//        function(type)
//    }
//
//    @objc
//    private func tapppped() {
//        print("hehe iiiiii")
//    }
//
//    private func reloadImageColor() {
//        let color: UIColor = state == .active ? .white : .lightGray
//        button.tintColor = color
//    }
//}
//extension Array where Element: TabBarItem {
//
//    func getItem(withIndex index: Int) -> TabBarItem? {
//        guard let type = TabBarItemType(rawValue: index) else { return nil }
//
//        return first(where: {
//            $0.type == type
//        })
//    }
//}
