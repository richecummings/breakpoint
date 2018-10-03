//
//  RoundedImage.swift
//  breakpoint
//
//  Created by Richard Cummings on 2018-10-02.
//  Copyright © 2018 Richard Cummings. All rights reserved.
//

import UIKit

@IBDesignable
class RoundedImage: UIImageView {
    
    @IBInspectable var cornerRadius: CGFloat = 3.0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    override func awakeFromNib() {
        self.setupView()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        self.setupView()
    }
    
    func setupView() {
        self.layer.cornerRadius = cornerRadius
    }
}
