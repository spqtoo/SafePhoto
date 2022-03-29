//
//  ImageViewerVC.swift
//  Safe Photo
//
//  Created by Nikolay Chepizhenko on 30.11.2021.
//

import UIKit

final class ImageViewerVC: BaseViewController {

    private lazy var model = diContainer.resolve(ImageViewerVCModelProtocol.self,
                                                 argument: album)!
    private let album: AlbumEntity
    private let startIndexPath: IndexPath
    private var indexPathState: NumberOfIndexPath = .first

    private lazy var collectionView: UICollectionView = {

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(ImageViewerCell.self, forCellWithReuseIdentifier: ImageViewerCell.identifier)
        collectionView.contentInsetAdjustmentBehavior = .never
        self.model.delegate = self

        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

//        setBackButtonAutomatically()
    }

    required init(album: AlbumEntity, indexPath: IndexPath) {
        self.album = album
        startIndexPath = indexPath
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    override func configureLayout() {
        super.configureLayout()

        collectionView.pin(to: view)
    }

}

extension ImageViewerVC: ImageViewerModelDelegate {
    
    func dataDidChange() {
        collectionView.reloadData()
//        MARK: не уверен надо ли [weak self] и здесь ли
        collectionView.performBatchUpdates(nil) { [weak self] index in
            guard let startIndex = self?.startIndexPath else { return }
            self?.collectionView.scrollToItem(at: startIndex, at: .centeredVertically, animated: false)
        }
    }
}

extension ImageViewerVC: UICollectionViewDelegate {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return Constants.numberOfCellsInRow
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollView.isPagingEnabled = true
    }

}

extension ImageViewerVC: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return model.pictures.count
    }

    func collectionView(_ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageViewerCell.identifier, for: indexPath) as? ImageViewerCell else { return UICollectionViewCell() }
        guard let model = model.pictures[safe: indexPath.item] else { return cell }

        cell.configure(with: model.image)

        return cell
    }

}

extension ImageViewerVC: UICollectionViewDelegateFlowLayout {


    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.size.width
        let height = view.frame.size.height

        return .init(width: width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: 0, bottom: 0, right: 0)
    }
}

extension ImageViewerVC {

    private enum NumberOfIndexPath {
        case first
        case `default`
    }

    private enum Constants {
        static let numberOfCellsInRow: Int = 1
    }
}

extension ImageViewerVC: DISupportable {}
