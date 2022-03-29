//
//  GlobalFunctions.swift
//  Safe Photo
//
//  Created by Nikolay Chepizhenko on 22.11.2021.
//

import YPImagePicker
import UIKit

func presentSinglePhotoPicker(from vc: UIViewController, completion: @escaping (UIImage?) -> Void) {
    var config = YPImagePickerConfiguration()
    config.screens = [.library]
    config.startOnScreen = .library
    //        config.library.defaultMultipleSelection = true
    config.showsPhotoFilters = false
    config.filters = []
    config.hidesBottomBar = true
    config.library.maxNumberOfItems = 1
    config.preferredStatusBarStyle = .darkContent
    config.isScrollToChangeModesEnabled = false
    let picker = YPImagePicker(configuration: config)

    picker.didFinishPicking { [unowned picker] items, _ in
        completion(items.singlePhoto?.image)
        picker.dismiss(animated: true, completion: nil)
    }
    vc.present(picker, animated: true)
}

extension CGFloat {
    var asRadians: CGFloat {
        return self * .pi/180
    }
}

func getDeleteButton(target: Any, selector: Selector) -> UIButton {
    let button = UIButton()
    button.setTitle(R.string.localizable.delete(), for: .normal)
    button.setTitleColor(.systemRed, for: .normal)
    button.addTarget(target, action: selector, for: .touchUpInside)
    return button
}

func getSelectButton(target: Any, selector: Selector) -> UIButton {
    let button = UIButton()
    button.setTitle(R.string.localizable.select(), for: .normal)
    button.setTitleColor(.white, for: .normal)
    button.addTarget(target, action: selector, for: .touchUpInside)
    return button
}

func getCancelButton(target: Any, selector: Selector) -> UIButton {
    let button = UIButton()
    button.setTitle(R.string.localizable.cancel(), for: .normal)
    button.setTitleColor(.white, for: .normal)
    button.addTarget(target, action: selector, for: .touchUpInside)
    return button
}
