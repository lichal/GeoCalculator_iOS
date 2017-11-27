//
//  GeoCalcTextFiled.swift
//  GeoCalculator
//
//  Created by Ryan Basso, Cheng Li on 10/13/17.
//  Copyright © 2017 Ryan Basso, Cheng Li. All rights reserved.
//

import UIKit

class GeoCalcTextFiled: DecimalMinusTextField {

    override func awakeFromNib() {
        self.tintColor = FOREGROUND_COLOR
        self.layer.borderWidth = 1.0
        self.layer.borderColor = FOREGROUND_COLOR.cgColor
        self.layer.cornerRadius = 5.0

        self.textColor = FOREGROUND_COLOR
        
        self.backgroundColor = UIColor.clear
        self.borderStyle = .roundedRect
        
        guard let ph = self.placeholder else {
            return
        }
        
        self.attributedPlaceholder =
            NSAttributedString(string: ph, attributes: [NSForegroundColorAttributeName :
                FOREGROUND_COLOR])
        
    }

}
