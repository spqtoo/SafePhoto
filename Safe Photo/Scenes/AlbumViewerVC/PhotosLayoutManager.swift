//
//  PhotosLayoutManager.swift
//  Image gallery
//
//  Created by Nikolay Chepizhenko on 07.09.2021.
//

import UIKit

final class PhotosLayoutManager {

    private(set) var cache: [String: UICollectionViewLayoutAttributes] = [:]
    private var evenSortedCache: [CGRect] {
        cache.filter { $0.value.frame.origin.x == GlobalConstants.horizontalInset }
            .compactMap { $0.value.frame }
            .sorted(by: { $0.maxY > $1.maxY })
    }
    private var oddSortedCache: [CGRect] {
        cache.filter { $0.value.frame.origin.x != GlobalConstants.horizontalInset }
            .compactMap { $0.value.frame }
            .sorted(by: { $0.maxY > $1.maxY })
    }

    private var cellWidth: CGFloat {
        return (superviewSize.width - horizontalMargin) / 2 - GlobalConstants.horizontalInset
    }

    private var minRowHeight: CGFloat {
        return cellWidth
    }

    private var maxRowHeight: CGFloat {
        return cellWidth * 2
    }

    private var randomRowHeight: CGFloat {
        return .random(in: minRowHeight...maxRowHeight)
    }

    private(set) var contentHeight: CGFloat = .zero

    var config: Config = .init() {
        didSet {
            guard oldValue != config else { return }
            prepare()
            lastConfig = config
        }
    }
    private lazy var lastConfig: Config = config

    func prepare() {
        if lastConfig.yOffset != config.yOffset {
            updatePositions()
            return
        }
//        cache = [:]
        contentHeight = .zero

        for index in .zero..<numberOfItems {
            let indexPath = IndexPath(item: index, section: section)
            guard !cache.keys.contains(indexPath.key) else { continue }
            let frame = rect(index: indexPath)

            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = frame
            cache[indexPath.key] = attributes

            contentHeight = max(contentHeight, frame.maxY)
        }
        contentHeight -= config.yOffset
    }

    func updatePositions() {

        contentHeight = .zero

        let cacheCopy = cache
        cache = [:]

        for index in .zero..<numberOfItems {
            let indexPath = IndexPath(item: index, section: section)
            var frame = rect(index: indexPath)

            if let size = cacheCopy[indexPath.key]?.frame.size {
                frame.size = size
            }

            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = frame
            cache[indexPath.key] = attributes

            contentHeight = max(contentHeight, attributes.frame.maxY)
        }
        contentHeight -= config.yOffset
    }

    private func rect(index: IndexPath) -> CGRect {
        return .init(origin: origin(index: index),
                     size: size(index: index))
    }

    private func origin(index: IndexPath) -> CGPoint {
        return .init(x: cellPositionByX(index: index),
                     y: cellPositionByY(index: index))
    }

    private func size(index: IndexPath) -> CGSize {
        return .init(width: cellWidth,
                     height: cellHeight(index: index))
    }

    private func cellHeight(index: IndexPath) -> CGFloat {
        if index.item % 5 == .zero { return Bool.random() ? minRowHeight : maxRowHeight }
        return .random(in: minRowHeight...maxRowHeight)
    }

    private func cellPositionByY(index: IndexPath) -> CGFloat {
        let isOdd = isOdd(index)
        let value = isOdd == .odd ? oddSortedCache.first : evenSortedCache.first

        let result = (value?.maxY ?? config.yOffset) + verticalMargin
        return result
    }

    private func cellPositionByX(index: IndexPath) -> CGFloat {
        let isOdd = isOdd(index)
        switch isOdd {
        case .even:
            return GlobalConstants.horizontalInset

        case .odd:
            return (cellWidth + GlobalConstants.horizontalInset) + horizontalMargin
        }
    }

    private func isOdd(_ index: IndexPath) -> CellType {
//        print("log: ", cache.compactMap { "\($0.key), \($0.value.frame.maxY)" })
        let index = index.item
        guard index != 0 else { return .even }
        guard index != 1 else { return .odd }
        let evenValue = Int(evenSortedCache.first!.maxY)
        let oddValue = Int(oddSortedCache.first!.maxY)

        if evenValue > oddValue {
            return .odd
        }
        else if evenValue <= oddValue {
            return .even
        }
        else {
            fatalError()
        }

//        let unwrapedValues = topValues.compactMap { $0.maxY }
//        let notTopValue = unwrapedValues.sorted(by: { $0 < $1 } ).reversed()[1]
//        print(notTopValue)
////        print(unwrapedValues.sorted())
//        if notTopValue == evenValue.maxY {
//            return .even
//        }
//        else if notTopValue == oddValue.maxY {
//            return .odd
//        }
//        else {
//            fatalError()
//        }
    }

    struct Config: Equatable {
        var numberOfItems: Int
        var section: Int
        var superviewSize: CGSize
        var horizontalMargin: CGFloat
        var verticalMargin: CGFloat
        var yOffset: CGFloat

        init() {
            numberOfItems = .zero
            section = .zero
            superviewSize = .zero
            horizontalMargin = .zero
            verticalMargin = .zero
            yOffset = .zero
        }

        init(numberOfItems: Int,
             section: Int,
             superviewSize: CGSize,
             horizontalMargin: CGFloat,
             verticalMargin: CGFloat,
             yOffset: CGFloat) {

            self.numberOfItems = numberOfItems
            self.section = section
            self.superviewSize = superviewSize
            self.horizontalMargin = horizontalMargin
            self.verticalMargin = verticalMargin
            self.yOffset = yOffset
        }
    }

    enum CellType {
        case even
        case odd
    }
}

// MARK: - Config properties

private extension PhotosLayoutManager {

    private var numberOfItems: Int { config.numberOfItems }
    private var section: Int { config.section }
    private var superviewSize: CGSize { config.superviewSize }
    private var horizontalMargin: CGFloat { config.horizontalMargin }
    private var verticalMargin: CGFloat { config.verticalMargin }
}
