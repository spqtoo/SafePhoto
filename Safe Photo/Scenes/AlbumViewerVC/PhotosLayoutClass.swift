//
//  PhotosLayout.swift
//  Image gallery
//
//  Created by Nikolay Chepizhenko on 11.09.2021.
//

import UIKit

final class VerticalPhotosLayout: UICollectionViewFlowLayout {

    //    weak var delegate: HashtagsLayoutDelegate?

    private let cellPadding: CGFloat = 4
    private let numberOfItemsH: CGFloat = 4
    private let numberOfItemsV: CGFloat = 4

    private var cache: [String: UICollectionViewLayoutAttributes] { layoutManager.cache }
    private var headersCache: UICollectionViewLayoutAttributes?

    override var collectionViewContentSize: CGSize {
        let isScrolling = collectionView?.yOffset ?? .zero > Self.minHeaderValue
        let headerHeight = headersCache?.frame.height ?? .zero
        let photosContentSize = layoutManager.contentHeight
//        let isLessThanScreen = UIScreen.height > photosContentSize

        let height = isScrolling ? photosContentSize + headerHeight + 32 : photosContentSize + Self.minHeaderValue + 32
//        print("hehe", height)
        return CGSize(width: UIScreen.width, height: height)
    }

    private let layoutManager = PhotosLayoutManager()

    override func prepare() {
        // 1
        guard let collection = collectionView else { fatalErrorIfDebug(); return }
        //        guard collection.numberOfSections > .zero else { fatalErrorIfDebug(); return }
        //        guard sections.count == collection.numberOfSections else { fatalErrorIfDebug(); return }
        //        let sectionsNum = collection.numberOfSections
        //        cache = [:]
        updatePhotosLayout()

        print("hehe", collection.yOffset)
        //        contentHeight = layoutManager.contentHeight
    }

    private func updatePhotosLayout() {
        guard let collection = collectionView else { fatalErrorIfDebug(); return }
        guard collectionView?.numberOfSections != .zero else { return }
        let numOfItems = collection.numberOfItems(inSection: .zero)

        headersCache = header()
        guard let headersCache = headersCache else { return }
        guard let collectionView = collectionView else { return }
        let y = min(.zero, collectionView.yOffset)

        layoutManager.config = .init(numberOfItems: numOfItems,
                                     section: .zero,
                                     superviewSize: .init(width: UIScreen.width,
                                                          height: .zero),
                                     horizontalMargin: 16,
                                     verticalMargin: 16,
                                     yOffset: headersCache.frame.height + y)
    }

    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }

    override var scrollDirection: UICollectionView.ScrollDirection {
        get { .vertical }
        set {}
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var visibleLayoutAttributes: [UICollectionViewLayoutAttributes] = []
        if let header = header() { visibleLayoutAttributes.append(header) }

        // Loop through the cache and look for items in the rect
        //        var finalCache = cache
        //        cache.forEach { finalCache[$0] = $1 }


        for attributes in cache.values {
            if attributes.frame.intersects(rect) {
                visibleLayoutAttributes.append(attributes)
            }
        }
        return visibleLayoutAttributes
    }

    private func header() -> UICollectionViewLayoutAttributes? {
        guard let collectionView = collectionView else { return nil }
        guard collectionView.numberOfSections > .zero else { return nil }
        let yOffset = collectionView.yOffset

        let index = IndexPath(row: .zero, section: .zero)
        let item = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, with: index)
        let y = min(.zero, yOffset)
        let height = max(Self.minHeaderValue, Self.minHeaderValue - yOffset)
        item.frame = .init(x: .zero, y: y, width: collectionView.bounds.width, height: height)
        return item
    }

    static let minHeaderValue: CGFloat = UIScreen.width * 1.2

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        //        fatalError()
        return cache["\(indexPath.item)"]
    }
}

//final class VerticalPhotosLayout: UICollectionViewFlowLayout {
//
//    //    weak var delegate: HashtagsLayoutDelegate?
//
//    private let cellPadding: CGFloat = 4
//    private let numberOfItemsH: CGFloat = 4
//    private let numberOfItemsV: CGFloat = 4
//
//    private var cache: [String: UICollectionViewLayoutAttributes] {
//        layoutManager.cache
//    }
//
//    override var collectionViewContentSize: CGSize {
//        return CGSize(width: UIScreen.width, height: layoutManager.contentHeight)
//    }
//
//    private let layoutManager = PhotosLayoutManager()
//
//    override func prepare() {
//        // 1
//        guard let collection = collectionView else { fatalErrorIfDebug(); return }
////        guard collection.numberOfSections > .zero else { fatalErrorIfDebug(); return }
////        guard sections.count == collection.numberOfSections else { fatalErrorIfDebug(); return }
////        let sectionsNum = collection.numberOfSections
////        cache = [:]
//        updatePhotosLayout()
////        contentHeight = layoutManager.contentHeight
//    }
//
//    private func updatePhotosLayout() {
//        guard let collection = collectionView else { fatalErrorIfDebug(); return }
//        guard collectionView?.numberOfSections != .zero else { return }
//        let numOfItems = collection.numberOfItems(inSection: .zero)
//
//        layoutManager.config = .init(numberOfItems: numOfItems,
//                                     section: .zero,
//                                     superviewSize: .init(width: UIScreen.width,
//                                                          height: .zero),
//                                     horizontalMargin: 16,
//                                     verticalMargin: 16,
//                                     yOffset: .zero)
//    }
//
//    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
//        return false
//    }
//
//    override var scrollDirection: UICollectionView.ScrollDirection {
//        get { .vertical }
//        set {}
//    }
//
//    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
//        var visibleLayoutAttributes: [UICollectionViewLayoutAttributes] = []
//
//        // Loop through the cache and look for items in the rect
////        var finalCache = cache
////        cache.forEach { finalCache[$0] = $1 }
//
//
//        for attributes in cache.values {
//            if attributes.frame.intersects(rect) {
//                visibleLayoutAttributes.append(attributes)
//            }
//        }
//        return visibleLayoutAttributes
//    }
//
//    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
//        //        fatalError()
//        return cache["\(indexPath.item)"]
//    }
//}
