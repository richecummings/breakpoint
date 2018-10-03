//
//  UIImageViewExt.swift
//  breakpoint
//
//  Created by Richard Cummings on 2018-10-02.
//  Copyright © 2018 Richard Cummings. All rights reserved.
//

import UIKit

extension UIImageView {
    func setRounded() {
        self.layer.cornerRadius = (self.frame.width / 2)
        self.layer.masksToBounds = true;
    }
}
