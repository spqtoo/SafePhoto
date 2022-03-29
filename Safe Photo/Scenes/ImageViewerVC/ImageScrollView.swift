//
//  ImageScrollView.swift
//  Safe Photo
//
//  Created by Степан Соловьёв on 04.12.2021.
//

import UIKit

class ImageScrollView : UIScrollView {
    override func layoutSubviews() {
        var which : Int {return 1}
        switch which {
        case 1:
            print("layout")
            super.layoutSubviews()
            if let v = self.delegate?.viewForZooming?(in:self) {
                let svw = self.bounds.width
                let svh = self.bounds.height
                let vw = v.frame.width
                let vh = v.frame.height
                var f = v.frame
                if vw < svw {
                    f.origin.x = (svw - vw) / 2.0
                } else {
                    f.origin.x = 0
                }
                if vh < svh {
                    f.origin.y = (svh - vh) / 2.0
                } else {
                    f.origin.y = 0
                }
                v.frame = f
            }
        default:break
        }
    }
}
