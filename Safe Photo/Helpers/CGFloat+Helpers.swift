//
//  CGFloat+Helpers.swift
//  Image gallery
//
//  Created by Nikolay Chepizhenko on 24.07.2021.
//

import UIKit

func minMax<T: Comparable>(min: T, current: T, max: T) -> T {
    switch current {
    case current where current > max:
        return max

    case current where current < min:
        return min

    default:
        return current
    }
}
