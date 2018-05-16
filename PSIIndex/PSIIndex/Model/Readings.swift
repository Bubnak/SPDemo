//
//  Readings.swift
//  PSIIndex
//
//  Created by Bubna Ratheesh on 16/5/18.
//  Copyright © 2018 Bubna Kbubna. All rights reserved.
//

import Foundation

class Readings: NSObject {
    let central: Double
    let east: Double
    let national: Double
    let north: Double
    let south: Double
    let west: Double
    let name: String
    init(name:String, central: Double, east: Double, national: Double, north: Double, south: Double, west: Double) {
        self.central = central
        self.east = east
        self.national = national
        self.north = north
        self.south = national
        self.west = north
        self.name = name
    }
}

class North: NSObject {
    let northDetails: String
    init(northDetails:String) {
        self.northDetails = northDetails
    }
}

