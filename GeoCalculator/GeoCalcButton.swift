//
//  GeoCalcButton.swift
//  GeoCalculator
//
//  Created by Ryan Basso, Cheng Li on 10/13/17.
//  Copyright © 2017 Ryan Basso, Cheng Li. All rights reserved.
//

import UIKit

class GeoCalcButton: UIButton {
    
    override func awakeFromNib() {
        self.backgroundColor = FOREGROUND_COLOR
        self.tintColor = BACKGROUND_COLOR
        self.layer.borderWidth = 1.0
        self.layer.borderColor = BACKGROUND_COLOR.cgColor
        self.layer.cornerRadius = 5.0
    }
}
