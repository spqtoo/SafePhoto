//
//  AlbumViewerVC.swift
//  Safe Photo
//
//  Created by Nikolay Chepizhenko on 21.11.2021.
//

import UIKit
import YPImagePicker
import Swinject

final class AlbumViewerVC: BaseViewController {

    static let bgColor: UIColor = .init(rgb: 0x111111)

    private var model: AlbumViewerModelProtocol

    private var screenState: ScreenState = .default {
        didSet {
            updateHeader()
            switch screenState {
            case .default:
                navigationItem.setLeftBarButton(nil, animated: true)
                navigationItem.setRightBarButton(editButtonBarButton, animated: true)

            case .selecting:
                navigationItem.setLeftBarButton(cancelNavBarTitle, animated: true)
                navigationItem.setRightBarButton(deleteNavBarTitle, animated: true)
            }
            navigationController?.interactivePopGestureRecognizer?.delegate = nil
//            self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        }
    }

    // MARK: - Properties

    private lazy var editButton: UIImageView = {
        let image = UIImageView()
        image.image = R.image.configure_icon()
        image.contentMode = .scaleAspectFit

        return image
    }()

    private lazy var deleteButton = getDeleteButton(target: self, selector: #selector(deleteDidPress))
    private lazy var cancelButton = getCancelButton(target: self, selector: #selector(cancelDidPress))

    private lazy var cancelNavBarTitle = UIBarButtonItem(customView: cancelButton)
    private lazy var deleteNavBarTitle = UIBarButtonItem(customView: deleteButton)
    private lazy var editButtonBarButton: UIBarButtonItem = .init(customView: editButtonContainer)

    private lazy var editButtonContainer: UIView = {
        let view = UIView()
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(configureDidPress)))
        editButton.centerVertically(to: view).pinAnchors(to: view, anchors: .right)
        view.setHeight(value: 60).widthToHeight()
        return view
    }()
    
    private var toolView: ToolBarStackView = {
        let view = ToolBarStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        return view
    }()

    private lazy var collectionView: UICollectionView = {
        let layout = VerticalPhotosLayout()

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(ImageCell.self, forCellWithReuseIdentifier: ImageCell.identifier)
        collectionView.register(CategoryViewerStretchyHeader.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: CategoryViewerStretchyHeader.identifier)
        collectionView.contentInsetAdjustmentBehavior = .never

        return collectionView
    }()

//    private let album: AlbumEntity

//    private lazy var errorView: ErrorView = .init(delegate: self)
    private var lastReloadedContentHeight: CGFloat = .zero

    required init(album: AlbumEntity, diContainer: Container) {
        //        guard interest.lowQualImageURL.isImageCached else { return nil }
        self.model = diContainer.resolve(AlbumViewerModelProtocol.self, argument: album)!
        super.init(nibName: nil, bundle: nil)
        self.hidesBottomBarWhenPushed = true
        //        extendedLayoutIncludesOpaqueBars = true
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        model.delegate = self
        model.reloadData()

//        configureNavBar()
//        setBackButtonAutomatically()
        navigationItem.setRightBarButton(UIBarButtonItem(image: R.image.configure_icon(), style: .plain, target: self, action: #selector(configureDidPress)), animated: false)
//        setImageViewToNavBar(R.image.configure_icon(),
//                             margin: 8,
//                             target: self,
//                             selector: #selector(configureDidPress),
//                             shouldWidthEqualsHeight: true,
//                             for: .right)

//        navigationItem.largeTitleDisplayMode = .never
//        navigationItem.title = ""

        view.backgroundColor = Self.bgColor
        collectionView.backgroundColor = .clear
        view.addSubview(toolView)
        NSLayoutConstraint.activate([
            toolView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            toolView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            toolView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            toolView.heightAnchor.constraint(equalToConstant: 65)
        ])
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        DispatchQueue.main.async {
//            self.navigationController?.setNavigationBarHidden(true, animated: true)
//        }
//        makeNavigationBarTransparent()
        //        updateNavBar(in: collectionView)
    }

    private var nav: UINavigationController? { navigationController }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        restoreNavigationBarTransparency()
        //        categoriesManager.viewWillDisappear()
    }

    override func layoutBottomAddButtonConstraint(button: UIView) {
        button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -32).isActive = true
    }

    override func addButtonDidPress() {

        var config = YPImagePickerConfiguration()
        config.screens = [.library]
        config.startOnScreen = .library
        config.library.defaultMultipleSelection = true
        config.showsPhotoFilters = false
        config.filters = []
        config.hidesBottomBar = true
        config.library.maxNumberOfItems = .max
        config.preferredStatusBarStyle = .darkContent
        config.isScrollToChangeModesEnabled = false

        let picker = YPImagePicker(configuration: config)
        picker.view.backgroundColor = .black

        picker.didFinishPicking { [unowned picker, weak self] items, _ in
            let images: [UIImage] = items.compactMap { if case let .photo(value) = $0 { return value.image }; return nil }
            self?.model.add(images)

            //            if let photo = items.singlePhoto {
            //                self?.selectedImage = photo.image
            //                print(photo.fromCamera) // Image source (camera or library)
            //                print(photo.image) // Final image selected by the user
            //                print(photo.originalImage) // original image selected by the user, unfiltered
            //                print(photo.modifiedImage) // Transformed image, can be nil
            //                print(photo.exifMeta) // Print exif meta data of original image.
            //            }
            picker.dismiss(animated: true, completion: nil)
        }
        present(picker, animated: true)
    }

    override func configureLayout() {
        super.configureLayout()
        collectionView.pin(to: view)
    }

    @objc
    private func deleteDidPress() {
        screenState = .default
    }

    @objc
    private func cancelDidPress() {
        screenState = .default
    }
}

private enum ViewerSection: Int, Hashable {
    case images
}

extension AlbumViewerVC: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let photoVC = ImageViewerVC(album: model.album, indexPath: indexPath)
        navigationController?.pushViewController(photoVC, animated: true)
    }
    

    func scrollViewDidScroll(_ scrollView: UIScrollView) {}
}

extension AlbumViewerVC: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model.images.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCell.identifier, for: indexPath) as! ImageCell
        guard model.images.indices.contains(indexPath.item) else { return cell }
        let model = model.images[indexPath.item]
        cell.configure(with: model.image)
        return cell
    }


    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CategoryViewerStretchyHeader.identifier, for: indexPath) as! CategoryViewerStretchyHeader
            guard let model = model.albumDto else { return header }
            header.configure(.init(name: model.albumName,
                                   image: model.image,
                                   itemsCount: self.model.countOfImages,
                                   isEditing: screenState == .selecting,
                                   lastUpdate: "сейчас"),
                             delegate: self)
            return header

        default:
            return .init()
        }
    }
}

private extension AlbumViewerVC {

    @objc
    private func configureDidPress() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: R.string.localizable.deleteAlbum(),
                                      style: .destructive,
                                      handler: { [weak self] action in
            self?.deleteAlbum()
        }))
        alert.addAction(UIAlertAction(title: R.string.localizable.editAlbum(),
                                      style: .default,
                                      handler: { [weak self] action in
            self?.editAlbum()
        }))
        alert.addAction(UIAlertAction(title: R.string.localizable.addPhotos(),
                                      style: .default,
                                      handler: { [weak self] action in
            self?.addButtonDidPress()
        }))
        alert.addAction(UIAlertAction(title: R.string.localizable.changeAlbumPhoto(),
                                      style: .default,
                                      handler: { [weak self] _ in
            self?.changeAlbumImage()
        }))
        alert.addAction(UIAlertAction(title: R.string.localizable.cancel(),
                                      style: .cancel,
                                      handler: { action in

        }))
        self.present(alert, animated: true, completion: nil)
    }

    private func editAlbum() {
        screenState = .selecting
    }

    private func deleteAlbum() {
        let alert = UIAlertController(title: R.string.localizable.albumViewerAreYouSure(model.albumDto?.albumName ?? ""),
                                      message: R.string.localizable.albumViewerDeleteAlbumDescription(),
                                      preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: R.string.localizable.yes(),
                                      style: .destructive,
                                      handler: { [weak self] _ in
            self?.model.deleteAlbum { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            }
        }))
        alert.addAction(UIAlertAction(title: R.string.localizable.cancel(),
                                      style: .cancel,
                                      handler: { action in

        }))
        present(alert, animated: true)
    }

    private func changeAlbumImage() {
        presentSinglePhotoPicker(from: self) { [weak self] image in
            if let image = image {
                self?.model.changeAlbum(image: image)
            }
        }
    }
}

extension AlbumViewerVC: AlbumViewerModelDelegate {

    func dataDidChange() {
        collectionView.reloadData()
    }

    func albumDidChange() {
        updateHeader()
    }

    private func updateHeader() {
        let header = collectionView.visibleSupplementaryViews(ofKind: UICollectionView.elementKindSectionHeader).first as? CategoryViewerStretchyHeader
        guard let model = model.albumDto else { return }
        header?.update(.init(name: model.albumName,
                             image: model.image,
                             itemsCount: self.model.countOfImages,
                             isEditing: screenState == .selecting,
                             lastUpdate: "сейчас"))
    }
}

extension AlbumViewerVC: CategoryViewerStretchyHeaderDelegate {

    func titleChanged(_ value: String) {
        model.titleChanged(value)
    }
}

extension AlbumViewerVC {

    enum ScreenState {
        case `default`
        case selecting
    }
}
