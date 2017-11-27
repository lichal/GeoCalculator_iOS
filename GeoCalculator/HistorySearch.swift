//
//  HistorySearch.swift
//  GeoCalculator
//
//  Created by Cheng Li, Ryan Basso on 10/30/17.
//  Copyright © 2017 Cheng Li, Ryan Basso. All rights reserved.
//

import Foundation

struct LocationLookup {
    var origLat:Double
    var origLng:Double
    var destLat:Double
    var destLng:Double
    var timestamp:Date
    
    init(origLat:Double, origLng:Double, destLat:Double, destLng:Double, timestamp:Date) {
        self.origLat = origLat
        self.origLng = origLng
        self.destLat = destLat
        self.destLng = destLng
        self.timestamp = timestamp
    }
}
