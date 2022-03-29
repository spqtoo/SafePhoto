////
////  BaseViewController.swift
////  Safe Photo
////
////  Created by Nikolay Chepizhenko on 21.11.2021.
////

import UIKit

class BaseViewController: UIViewController {

    enum StateAddButton {
        case blue
        case red
    }
    
    private(set) lazy var addButton: UIImageView = {
        let button = UIImageView()
        button.image = UIImage(systemName: "plus")
        button.tintColor = .white
        button.contentMode = .scaleAspectFill
//        button.setTitle("+", for: .normal)
//        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private(set) lazy var addButtonBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = ColorManager.addButtonBlue
        view.layer.cornerRadius = 35
        view.clipsToBounds = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(addButtonDidPress))
        view.addGestureRecognizer(tapGesture)
        view.isUserInteractionEnabled = true
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        configureAddButtonLayout()
        layoutBottomAddButtonConstraint(button: addButton)

        configureLayout()
        configureColors()
    }

//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//
//        addButtonBottomConstraint.constant = -(tabBarController?.stackTopPoint ?? .zero) - 24
//    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        view.bringSubviewToFront(addButtonBackgroundView)
        view.bringSubviewToFront(addButton)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        print("??????/")
        super.traitCollectionDidChange(previousTraitCollection)
        
        configureColors()
    }
    
    @objc
    func addButtonDidPress() {}

    func layoutBottomAddButtonConstraint(button: UIView) {}

    func configureLayout() {

    }
    
    func configureColors() {
        
    }
    

    private func configureAddButtonLayout() {
        view.addSubview(addButtonBackgroundView)
        view.addSubview(addButton)

//        let bottomMargin = (tabBarController?.stackTopPoint ?? .zero)

        NSLayoutConstraint.activate([
            addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                                constant: -42),
            addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -42)
        ])

//        let rad: CGFloat = 45 * .pi/180

        addButton.setHeight(value: 30).widthToHeight()
        addButtonBackgroundView.pin(to: addButton, margin: -20)
//        addButtonBackgroundView.transform = .init(rotationAngle: rad)
    }
}
//
//class BaseViewControllerWithNavBar: AutomaticBackButtonViewController {
//
//    private(set) lazy var addButton: UIImageView = {
//        let button = UIImageView()
//        button.image = R.image.add_icon()
//        button.tintColor = .white
//        button.contentMode = .scaleAspectFill
//        //        button.setTitle("+", for: .normal)
//        //        button.setTitleColor(.white, for: .normal)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        return button
//    }()
//
//    private lazy var addButtonBackgroundView: UIView = {
//        let view = UIView()
//        view.backgroundColor = .init(rgb: 0x333333)
//        view.layer.cornerRadius = 20
//        view.clipsToBounds = true
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(addButtonDidPress))
//        view.addGestureRecognizer(tapGesture)
//        view.isUserInteractionEnabled = true
//        return view
//    }()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        configureAddButtonLayout()
//        layoutBottomAddButtonConstraint(button: addButton)
//    }
//
//    //    override func viewDidLayoutSubviews() {
//    //        super.viewDidLayoutSubviews()
//    //
//    //        addButtonBottomConstraint.constant = -(tabBarController?.stackTopPoint ?? .zero) - 24
//    //    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//
//        view.bringSubviewToFront(addButtonBackgroundView)
//        view.bringSubviewToFront(addButton)
//    }
//
//    @objc
//    func addButtonDidPress() {}
//
//    func layoutBottomAddButtonConstraint(button: UIView) {}
//
//    private func configureAddButtonLayout() {
//        view.addSubview(addButtonBackgroundView)
//        view.addSubview(addButton)
//
//        //        let bottomMargin = (tabBarController?.stackTopPoint ?? .zero)
//
//        NSLayoutConstraint.activate([
//            addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor,
//                                                constant: -24)
//        ])
//
//        let rad: CGFloat = 45 * .pi/180
//
//        addButton.setHeight(value: 30).widthToHeight()
//        addButtonBackgroundView.pin(to: addButton, margin: -12)
//        addButtonBackgroundView.transform = .init(rotationAngle: rad)
//    }
//}
//final class AnimateAddButton {
//
//    func vibroMinimal() { vibro(.minimal) }
//
//    func vibro(_ style: VibroStyle) {
//
//        DispatchQueue.main.async {
//
//            if style == .light || style == .medium || style == .heavy {
//                var vibroStyle: UIImpactFeedbackGenerator.FeedbackStyle = .light
//                if style == .light { vibroStyle = .light }
//                if style == .medium { vibroStyle = .medium }
//                if style == .heavy { vibroStyle = .heavy }
//                UIImpactFeedbackGenerator(style: vibroStyle).impactOccurred()
//            }
//            if style == .success || style == .warning || style == .error {
//                var vibroStyle: UINotificationFeedbackGenerator.FeedbackType = .success
//                if style == .success { vibroStyle = .success }
//                if style == .warning { vibroStyle = .warning }
//                if style == .error { vibroStyle = .error }
//                UINotificationFeedbackGenerator().notificationOccurred(vibroStyle)
//            }
//
//            if style == .minimal { UISelectionFeedbackGenerator().selectionChanged() }
//
//        }
//    }
//
//    enum VibroStyle {
//        case light, medium, heavy, success, warning, error, minimal
//    }
//
//}
