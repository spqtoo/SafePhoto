//
//  NSNotification+Helpers.swift
//  Safe Photo
//
//  Created by Nikolay Chepizhenko on 21.11.2021.
//

import UIKit

extension NSNotification {

    var keyboardAnimation: TimeInterval {
        (userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0.3 as TimeInterval
    }

    var keyboardHeight: CGFloat {
        let value = userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
        return value?.cgRectValue.height ?? .zero
    }
}
