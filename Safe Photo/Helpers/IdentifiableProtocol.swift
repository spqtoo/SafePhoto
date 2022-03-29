//
//  IdentifiableProtocol.swift
//  Safe Photo
//
//  Created by Степан Соловьёв on 02.11.2021.
//

import UIKit

protocol IdentifiableProtocol {

    // MARK: - Properties

    static var identifier: String { get }
}

extension IdentifiableProtocol {

    // MARK: - Properties

    static var identifier: String {
        return String(describing: self)
    }
}
