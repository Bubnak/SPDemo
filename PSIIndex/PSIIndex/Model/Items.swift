//
//  Items.swift
//  PSIIndex
//
//  Created by Bubna Ratheesh on 16/5/18.
//  Copyright © 2018 Bubna Kbubna. All rights reserved.
//

import Foundation
class Items: NSObject {
    let timeStamp: String
    let updateTimeStamp: String
    let readings: [Readings]
    
    
    init(timeStamp: String, updateTimeStamp:String, readings: [Readings]) {
        self.timeStamp = timeStamp
        self.updateTimeStamp = updateTimeStamp
        self.readings = readings
    }
}
