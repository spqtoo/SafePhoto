//
//  DISupportable.swift
//  Safe Photo
//
//  Created by Nikolay Chepizhenko on 21.11.2021.
//

import Foundation
import Swinject

fileprivate let container = Container()

protocol DISupportable {}

extension DISupportable {
    var diContainer: Container {
        get {
            return container
        }
    }
}
