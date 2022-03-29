//
//  ScrollView+Helper.swift
//  Image gallery
//
//  Created by Nikolay Chepizhenko on 07.08.2021.
//

import UIKit

extension UIScrollView {
    var visibleRect: CGRect {
        return .init(x: xOffset, y: yOffset, width: visibleWidth, height: visibleHeight)
    }

    var visibleWidth: CGFloat {
        visibleSize.width
    }

    var visibleHeight: CGFloat {
        visibleSize.width
    }

    var contentWidth: CGFloat {
        contentSize.width
    }

    var contentHeight: CGFloat {
        contentSize.height
    }

    var xOffset: CGFloat {
        contentOffset.x
    }

    var yOffset: CGFloat {
        contentOffset.y
    }
}

extension UIScrollView {

    // MARK: - Properties

    var verticalScrollPosition: CGFloat {
        let contentHeight = contentHeight
        let scrolledValue = yOffset + UIScreen.height
        let result = (scrolledValue * 100) / contentHeight
        return minMax(min: .zero, current: result, max: 100)
    }

//    var horizontalScrollPosition: Double {
//        let contentWidth = Double(contentWidth)
//        guard contentWidth > .zero else { return .zero }
//        return (Constants.hundredPercents / contentWidth) * Double(xOffset)
//    }

    // MARK: - Types

    enum Constants {
        static let hundredPercents: Double = 100.0
    }
}
