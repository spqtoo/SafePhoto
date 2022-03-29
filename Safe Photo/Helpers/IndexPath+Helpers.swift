//
//  IndexPath+Helpers.swift
//  Safe Photo
//
//  Created by Nikolay Chepizhenko on 21.11.2021.
//

import Foundation

extension IndexPath {

    var key: String {
        return "\(item).\(section)"
    }
}
