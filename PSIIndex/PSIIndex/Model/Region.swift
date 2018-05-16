//
//  Region.swift
//  PSIIndex
//
//  Created by Bubna Ratheesh on 16/5/18.
//  Copyright © 2018 Bubna Kbubna. All rights reserved.
//

import Foundation
class Region: NSObject {
    let latitude: Double
    let longitude: Double
    let name: String
   
    
    init(name: String, latitude:Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
        self.name = name
    }
}
