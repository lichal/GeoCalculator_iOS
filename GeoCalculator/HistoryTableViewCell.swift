//
//  HistoryTableViewCell.swift
//  GeoCalculator
//
//  Created by Cheng Li, Ryan Basso on 10/31/17.
//  Copyright © 2017 Cheng Li, Ryan Basso. All rights reserved.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var origPoint: UILabel!

    @IBOutlet weak var destPoint: UILabel!
    
    @IBOutlet weak var timestamp: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
