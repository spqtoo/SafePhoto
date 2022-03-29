//
//  RootTabBarController.swift
//  Image gallery
//
//  Created by Nikolay Chepizhenko on 17.04.2021.
//

import UIKit

//protocol ScrollableVC {
//    func scrollToTop()
//}
//final class CustomTabBar: UITabBar {
//
//    var myView: [UIView] {
//        return subviews.filter { $0.isHidden == false }.first?.subviews ?? []
//    }
//
//    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
//        //        print("hehe", subviews, #function)
//        let pointIsInside = super.point(inside: point, with: event) // 1
//        if pointIsInside == false { // 2
//            for subview in myView { // 2.1
//                let pointInSubview = subview.convert(point, from: self) // 2.2
//                print("hehe iterating", pointInSubview.y, point.y)
//                if subview.point(inside: pointInSubview, with: event) { // 2.3
//                    print("hehe return trueh")
//                    return true // 2.3.1
//                }
//            }
//        }
//        return pointIsInside // 3
//    }
//}
//
//final class RootTabBarController: UITabBarController {
//
//    // MARK: - Properties
//
//    static func build() -> RootTabBarController {
//        UIStoryboard(name: "TabBarStory", bundle: nil).instantiateViewController(withIdentifier: "Hehe") as! RootTabBarController
//    }
//
//    private var state: State = .showed
//
//    private var stackView = UIStackView()
//    private lazy var items: [TabBarItem] = {
//        return TabBarItemType.allCases.map {
//            return TabBarItem(type: $0, function: itemPressed(_:))
//        }
//    }()
//    private lazy var stackContainer: UIView = {
//        let view = UIView()
//        stackView.pinAnchors(to: view, anchors: .left, .right)
//        stackView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
//        //        stackView.pin(to: view)
//        return view
//    }()
//
//    var random: UIView? {
//        stackView.subviews.randomElement()
//    }
//
//    override var selectedIndex: Int {
//        didSet {
//            let currentItem = items.getItem(withIndex: selectedIndex)
//            items.forEach {
//
//                if currentItem?.type == $0.type {
//                    currentItem?.state = .active
//
//                } else {
//                    $0.state = .inactive
//                }
//            }
//            updateSelectedView()
//        }
//    }
//
//    private let selectedView: UIView = {
//        let view = UIView()
//        view.backgroundColor = .white.withAlphaComponent(0.1)
//        view.clipsToBounds = true
//        view.layer.cornerRadius = 20
//        view.isUserInteractionEnabled = false
//        return view
//    }()
//
//    // MARK: Methods
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        setItems()
//        setConstraints()
//
//        stackView.backgroundColor = .init(rgb: 0x191D24)
//        stackView.layer.cornerRadius = 20
//    }
//
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        print("hehe", touches.first?.view)
//    }
//
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//
//        //        tabBar.itemWidth = .zero
//        tabBar.subviews.forEach { $0.isHidden = !($0 === stackContainer) }
//        tabBar.items?.forEach { $0.isEnabled = false }
//        //        tabBar.frame.size.height = stackContainer.globalFrame.height
//        //        tabBar.frame.origin.y = stackContainer.globalFrame.origin.y
//    }
//
//    private func setItems() {
//        viewControllers = items.map {
//            stackView.addArrangedSubview($0.buttonContainer)
//            return $0.viewController
//        }
//    }
//    fileprivate var bottomConstant: CGFloat {
//        guard let window = UIApplication.shared.windows.first else { return .zero }
//        let value: CGFloat = window.safeAreaInsets.bottom == .zero ? 20 : .zero
//        return -value
//    }
//
//    private lazy var bottomConstraint = stackView.bottomAnchor.constraint(equalTo: tabBar.safeAreaLayoutGuide.bottomAnchor,
//                                                                          constant: bottomConstant)
//    fileprivate let height: CGFloat = 60
//
//    private func setConstraints() {
//        stackView.addSubview(selectedView)
//        tabBar.addSubview(stackContainer)
//        stackContainer.translatesAutoresizingMaskIntoConstraints = false
//
//        stackView.translatesAutoresizingMaskIntoConstraints = false
//        stackView.distribution = .fillEqually
//
//        stackContainer.heightAnchor.constraint(equalToConstant: height).isActive = true
//        stackContainer.leadingAnchor.constraint(equalTo: self.tabBar.leadingAnchor, constant: 40).isActive = true
//        stackContainer.trailingAnchor.constraint(equalTo: self.tabBar.trailingAnchor, constant: -40).isActive = true
//        stackContainer.bottomAnchor.constraint(equalTo: self.tabBar.safeAreaLayoutGuide.bottomAnchor, constant: bottomConstant).isActive = true
//        bottomConstraint.isActive = true
//
//        updateSelectedView()
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//
//        updateInsets()
//    }
//
//    func updateInsets() {
//        bottomConstraint.constant = bottomConstant
//    }
//
//    fileprivate func hide() {
//        state = .hidden
//        animate(value: height * 2 + view.safeAreaInsets.bottom, duration: 0.5)
//    }
//
//    fileprivate func show() {
//        state = .showed
//        animate(value: .zero, duration: 0.3)
//    }
//
//    fileprivate func animate(value: CGFloat, duration: TimeInterval) {
//        UIView.animate(withDuration: duration,
//                       delay: .zero,
//                       usingSpringWithDamping: 0.6,
//                       initialSpringVelocity: 1,
//                       options: .curveEaseInOut) { [weak self] in
//            guard let self = self else { return }
//            self.bottomConstraint.constant = value + self.bottomConstant
//            self.stackContainer.setNeedsLayout()
//            self.stackContainer.layoutIfNeeded()
//        }
//    }
//
//    private func updateSelectedView() {
//        view.setNeedsLayout()
//        view.layoutIfNeeded()
//        let index = selectedIndex
//        guard stackView.arrangedSubviews.indices.contains(index) else { fatalErrorIfDebug(); return }
//        let view = stackView.arrangedSubviews[index]
//        UIView.animate(withDuration: 0.3,
//                       delay: .zero,
//                       usingSpringWithDamping: 0.8,
//                       initialSpringVelocity: 1,
//                       options: .curveEaseInOut) { [weak self] in
//            guard let self = self else { return }
//            guard let button = view.subviews.first else { fatalErrorIfDebug(); return }
//            let width = button.frame.width + 20
//            let height = button.frame.height + 20
//            let x = view.frame.midX - width / 2
//            let y = self.height / 2 - height / 2
//
//            self.selectedView.frame = .init(x: x, y: y, width: width, height: height)
//            self.stackView.setNeedsLayout()
//            self.stackView.layoutIfNeeded()
//        }
//    }
//
//    func itemPressed(_ value: TabBarItemType) {
//        let index = value.rawValue
//        if index == selectedIndex,
//           let viewControllers = viewControllers,
//           viewControllers.indices.contains(index) {
//            let vc = viewControllers[index]
//            let nav = vc as? UINavigationController
//            let controllerFromNav = nav?.viewControllers.first
//            let controller = controllerFromNav ?? vc
//            let finalController = controller as? ScrollableVC
//            finalController?.scrollToTop()
//        }
//        selectedIndex = value.rawValue
//    }
//
//    static var controller: RootTabBarController? {
//        UIApplication.shared.windows.filter { $0.isKeyWindow }.first?.rootViewController as? RootTabBarController
//    }
//
//    static func hide() {
//        guard controller?.state == .showed else { return }
//        //        DispatchQueue.main.async {
//        controller?.hide()
//        //        }
//    }
//
//    static func show() {
//        guard controller?.state == .hidden else { return }
//        //        DispatchQueue.main.async {
//        controller?.show()
//        //        }
//    }
//
//    static func update(view: UIView) {
//        DispatchQueue.main.async {
//            guard let scrollView = view as? UIScrollView else {
//                show()
//                return
//            }
//            let velocity = scrollView.panGestureRecognizer.translation(in: nil).y
//
//            let isToUp = velocity >= .zero
//
//            if isToUp {
//                show()
//            }
//            else {
//                hide()
//            }
//        }
//    }
//}
//
//extension RootTabBarController {
//    private enum State {
//        case showed
//        case hidden
//    }
//}
//
//extension UITabBarController {
//    var stackTopPoint: CGFloat {
//        guard let root = self as? RootTabBarController else { return .zero }
//        let value = abs(root.bottomConstant) + root.height + root.view.safeAreaInsets.bottom
//        print("hehe", root.bottomConstant, root.height, root.view.safeAreaInsets.bottom, value)
//        return value
//    }
//}

final class RootTabBarController: UITabBarController {
    
//    private lazy var items: [TabBarItem] = {
//            return TabBarItemType.allCases.map {
//                return TabBarItem(type: $0, function: itemPressed(_:))
//            }
//        }()
//
//    override var selectedIndex: Int {
//            didSet {
//                let currentItem = items.getItem(withIndex: selectedIndex)
//                items.forEach {
//
//                    if currentItem?.type == $0.type {
//                        currentItem?.state = .active
//
//                    } else {
//                        $0.state = .inactive
//                    }
//                }
////                updateSelectedView()
//            }
//        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTabBar()
    }
    
//    private func setItems() {
//            viewControllers = items.map {
////                stackView.addArrangedSubview($0.buttonContainer)
//                return $0.viewController
//            }
//        }
    
    private func navigController(root: UIViewController, title: String, image: UIImage, tag: Int) -> UINavigationController {
        let item = UITabBarItem(title: title, image: image, tag: tag)
        let nav = UINavigationController(rootViewController: root)
        nav.navigationItem.largeTitleDisplayMode = .always
        nav.navigationBar.prefersLargeTitles = true
        nav.tabBarItem = item
        return nav
    }
    
    private func configureTabBar() {
        
        configureColors()
//        tabBar.backgroundColor = ColorManager.tabBarColor
        if #available(iOS 15.0, *) {
                    let appearance = UITabBarAppearance()
                    appearance.configureWithOpaqueBackground()
        //            appearance.backgroundColor = .red

        //            tabBar.standardAppearance = appearance
                    tabBar.scrollEdgeAppearance = tabBar.standardAppearance
                }

        
        let albumVC = navigController(root: AlbumPhotoCollectionViewController(),
                                      title: R.string.localizable.albumsTitle() ?? "",
                                      image: UIImage(systemName: "house") ?? UIImage(),
                                      tag: TabBarItemType.albums.rawValue)
        
        let settingsVC = navigController(root: SettingsViewController(),
                                         title: R.string.localizable.settingsTitle() ?? "",
                                         image: R.image.settings_icon() ?? UIImage(),
                                         tag: TabBarItemType.settings.rawValue)
        
        
        viewControllers = [albumVC, settingsVC]
        
        
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        configureColors()
    }
    
    private func configureColors() {
        tabBar.tintColor = ColorManager.primaryColor
    }
    
//    func itemPressed(_ value: TabBarItemType) {
//            let index = value.rawValue
//            if index == selectedIndex,
//               let viewControllers = viewControllers,
//               viewControllers.indices.contains(index) {
//                let vc = viewControllers[index]
//                let nav = vc as? UINavigationController
//                let controllerFromNav = nav?.viewControllers.first
//                let controller = controllerFromNav ?? vc
////              let finalController = controller as? ScrollableVC
////                                finalController?.scrollToTop()
//            }
//            selectedIndex = value.rawValue
//        }
}
