//
//  ViewController.swift
//  Safe Photo
//
//  Created by Nikolay Chepizhenko on 01.11.2021.
//

import UIKit

final class AlbumPhotoCollectionViewController: BaseViewController {

    private lazy var model = diContainer.resolve(AlbumsModelProtocol.self)!

    private lazy var selectNavBarTitle = UIBarButtonItem(customView: selectButton)
    private lazy var cancelNavBarTitle = UIBarButtonItem(customView: cancelButton)
    private lazy var deleteNavBarTitle = UIBarButtonItem(customView: deleteButton)

    private var screenState: ScreenState = .default {
        didSet {
            updateCells()
            switch screenState {
            case .default:
//                removeNavBarView(type: .left)
//                setNavBarItem(view: selectButton, for: .right)
                navigationItem.setLeftBarButton(nil, animated: true)
                navigationItem.setRightBarButton(selectNavBarTitle, animated: true)

            case .selecting:
//                setNavBarItem(view: cancelButton, for: .left)
//                setNavBarItem(view: deleteButton, for: .right)
                navigationItem.setLeftBarButton(cancelNavBarTitle, animated: true)
                navigationItem.setRightBarButton(deleteNavBarTitle, animated: true)
            }
        }
    }

    private lazy var deleteButton = getDeleteButton(target: self, selector: #selector(deleteDidPress))
    private lazy var cancelButton = getCancelButton(target: self, selector: #selector(cancelDidPress))
    private lazy var selectButton = getSelectButton(target: self, selector: #selector(selectDidPress))

    private var addButtonBottomConstraint: NSLayoutConstraint?

    private var animator = UIViewPropertyAnimator()
    private let transForBlue: CGFloat = 45 * .pi/180
    private let transForRed: CGFloat = 45 * .pi*180
//    private var addButtonBotConstraint = NSLayoutConstraint()
//    private var addButtonTrailConstraint = NSLayoutConstraint()
//    private var addButtonLeadConstraint = NSLayoutConstraint()
//    private var addButtonWidConstraint = NSLayoutConstraint()
//    private var addButtonHeigConstraint = NSLayoutConstraint()
    
    private var currentStateAddButton: StateAddButton = .blue
    
    // MARK:  CollectionView
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical

        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(CustomAlbumCollectionViewCell.self,
                                forCellWithReuseIdentifier:
                                    CustomAlbumCollectionViewCell.identifier)
        collectionView.backgroundColor = .clear
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        configureColors()
        screenState = .default
        model.delegate = self
        reloadData()

        configureNavBar()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1000)) {
//            self.navigationController?.setNavigationBarHidden(false, animated: true)
//            self.view.setNeedsLayout()
//            self.view.layoutIfNeeded()
//        }
        reloadData()
    }

//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//
//        let viewController = UIViewController()
//        viewController.view.backgroundColor = .systemGreen
//
//        let viewController2 = UIViewController()
//        viewController2.view.backgroundColor = .systemRed
//
//        present(viewController, animated: true, completion: nil)
////        viewController.present(viewController2, animated: true, completion: nil)
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3)) {
//            viewController.dismiss(animated: true, completion: nil)
//        }
//    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        navigationController?.navigationBar.sizeToFit()
//        tabBarController?.tabBar.sizeToFit()
    }

    override func layoutBottomAddButtonConstraint(button: UIView) {
        addButtonBottomConstraint = button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -24)
        addButtonBottomConstraint?.isActive = true
    }

    private func setBg() {
//        view.backgroundColor = ColorManager.homeScreenBg
//        let imageView = UIImageView(image: R.image.home_bg())
//        imageView.contentMode = .scaleAspectFill
//        imageView.pin(to: view)

//        view.sendSubviewToBack(imageView)
    }
    
    override func configureColors() {
        super.configureColors()
        
        view.backgroundColor = ColorManager.homeScreenBg
    }

    override func configureLayout() {
        super.configureLayout()
        addSubviews()

        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    @objc
    private func deleteDidPress() {
        model.deleteSelected()
        screenState = .default
    }

    @objc
    private func cancelDidPress() {
        model.deselectAll()
        screenState = .default
    }

    @objc
    private func selectDidPress() {
        model.deselectAll()
        screenState = .selecting
    }

    override func addButtonDidPress() {
        super.addButtonDidPress()
//        addButton.

        switch currentStateAddButton {
        case .blue:
            animator = UIViewPropertyAnimator(duration: 0.5, curve: .easeInOut, animations: {
                [unowned self] in
             
                self.addButton.backgroundColor = ColorManager.addButtonRed
                self.addButtonBackgroundView.backgroundColor = ColorManager.addButtonRed
                self.addButton.transform = .init(rotationAngle: self.transForBlue)
//                let objAnime = AnimateAddButton()
//                objAnime.vibroMinimal()
//                AnimateAddButton.vibroMinimal()
                vibroMinimal()
            })
//            vibroMinimal()
            
            addButton.startAnimating()
            animator.startAnimation()
            currentStateAddButton = .red
        case .red:
            animator = UIViewPropertyAnimator(duration: 0.5, curve: .easeInOut, animations: {
                [unowned self] in
             
                self.addButton.backgroundColor = ColorManager.addButtonBlue
                self.addButtonBackgroundView.backgroundColor = ColorManager.addButtonBlue
                self.addButton.transform = .init(rotationAngle: self.transForRed)
             
            })
            animator.startAnimation()
            currentStateAddButton = .blue
        }
        

//        let vc = AddAlbumVC.build(delegate: self)
//        present(vc, animated: true)
    }

    private func addSubviews() {
        view.addSubview(collectionView)
    }

    private func configureNavBar() {
//        setLargeTitle("Albums")
        navigationItem.title = "Альбомы"
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    private func reloadData() {
        model.reloadData()
    }
}

extension AlbumPhotoCollectionViewController: AlbumsModelDelegate {

    func dataDidChange() {
        collectionView.reloadData()
    }

    func updateCells() {
        let cells = collectionView.visibleCells.compactMap { $0 as? CustomAlbumCollectionViewCell }
        let values: [(IndexPath, CustomAlbumCollectionViewCell)] = cells.compactMap {
            guard let indexPath = collectionView.indexPath(for: $0) else { return nil }
            return (indexPath, $0)
        }
        values.forEach {
            guard model.items.indices.contains($0.0.item) else { return }
            let item = model.items[$0.0.item]
            let isSelecting = screenState == .selecting
            let isSelected = model.isAlbumSelected(item)

            $0.1.update(.init(isSelecting: isSelecting,
                              isSelected: isSelected))
        }
    }
}


    // MARK: ext.CollectionViewDelegateFlowLayout
extension AlbumPhotoCollectionViewController: UICollectionViewDelegateFlowLayout {

    private var numberOfCellsInRow: CGFloat { Constants.numberOfCellsInRow }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = cellWidth(collectionView,
                              layout: collectionViewLayout,
                              sizeForItemAt: indexPath)
        let height = cellHeight(collectionView,
                                layout: collectionViewLayout,
                                sizeForItemAt: indexPath)
        return .init(width: width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }

    private func cellHeight(_ collectionView: UICollectionView,
                            layout collectionViewLayout: UICollectionViewLayout,
                            sizeForItemAt indexPath: IndexPath) -> CGFloat {
        return cellWidth(collectionView, layout: collectionViewLayout,
                         sizeForItemAt: indexPath)
    }

    private func cellWidth(_ collectionView: UICollectionView,
                           layout collectionViewLayout: UICollectionViewLayout,
                           sizeForItemAt indexPath: IndexPath) -> CGFloat {
        let lineSpacing = self.collectionView(collectionView,
                                              layout: collectionViewLayout,
                                              minimumLineSpacingForSectionAt: indexPath.section)

        let insets = self.collectionView(collectionView,
                                         layout: collectionViewLayout,
                                         insetForSectionAt: indexPath.section)
        let hInsets = insets.left + insets.right
        let lineSpacingTotal = lineSpacing * (numberOfCellsInRow - 1)
        let collectionWidth = collectionView.bounds.width - lineSpacingTotal - hInsets
        let cellWidth = collectionWidth / numberOfCellsInRow
        return cellWidth
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 16, left: 16, bottom: 16, right: 16)
    }
}

// MARK: ext. CollectionViewDelegate
extension AlbumPhotoCollectionViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        guard model.items.indices.contains(indexPath.item) else { return }
        let album = model.items[indexPath.item]

        switch screenState {
        case .default:
            openCell(indexPath: indexPath, item: album)

        case .selecting:
            selectCell(indexPath: indexPath, item: album)
        }
    }

    private func selectCell(indexPath: IndexPath, item: Album) {
        model.select(album: item)
    }

    private func openCell(indexPath: IndexPath, item: Album) {
        guard let entity = model.entity(for: item) else { return }
        let vc = AlbumViewerVC(album: entity, diContainer: diContainer)
        navigationController?.pushViewController(vc, animated: true)
    }

//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        RootTabBarController.update(view: scrollView)
//    }
}

// MARK: ext.CollectionViewDataSource
extension AlbumPhotoCollectionViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return model.items.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomAlbumCollectionViewCell.identifier,
                                                      for: indexPath) as! CustomAlbumCollectionViewCell
        guard model.items.indices.contains(indexPath.item) else { return cell }
        let item = model.items[indexPath.item]
        let isSelecting = screenState == .selecting
        let isSelected = model.isAlbumSelected(item)
        cell.configure(.init(album: item,
                             selectingModel: .init(isSelecting: isSelecting,
                                                   isSelected: isSelected)))

        return cell
    }
}

extension AlbumPhotoCollectionViewController: AddAlbumVCDelegate {

    func didCreateImage() {
        reloadData()
    }
}

private extension AlbumPhotoCollectionViewController {

    private enum Constants {
        static let numberOfCellsInRow: CGFloat = 2
    }
}

// MARK: Enums
private enum ScreenState {
    case `default`
    case selecting
}

extension AlbumPhotoCollectionViewController: DISupportable {}
