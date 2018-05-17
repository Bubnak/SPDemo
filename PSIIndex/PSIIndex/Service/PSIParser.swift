//
//  PSIParser.swift
//  PSIIndex
//
//  Created by Bubna Ratheesh on 16/5/18.
//  Copyright © 2018 Bubna Kbubna. All rights reserved.
//

import UIKit

class PSIParser: PSIService {

    func parseRegionResults(regionResponse:JSONDictionary) -> ( [Region]){
        guard let arrayRegion = regionResponse["region_metadata"] as? [Any] else {
            errorMessage += "Dictionary does not contain results key\n"
            return []
        }
        
        
        for regionDictionary in arrayRegion {
            if let regionDictionary = regionDictionary as? JSONDictionary,
                let labelLocation = regionDictionary["label_location"] as? NSDictionary,
                let name = regionDictionary["name"] as? String {
                let latitude = labelLocation["latitude"] as? Double
                let longitude = labelLocation["longitude"] as? Double
                region.append(Region(name: name, latitude: latitude!,longitude: longitude!))
            } else {
                errorMessage += "Problem parsing trackDictionary\n"
            }
        }
        return region
    }
    
    func parseItemResults(response:JSONDictionary) -> (Items?){
        
        
        guard let arrayReadings = response["items"] as? [Any] else {
            errorMessage += "Dictionary does not contain results key\n"
            return items
        }
        
        for readingsDictionary in arrayReadings {
            if let readingsDictionary = readingsDictionary as? JSONDictionary,
                let timeStamp = readingsDictionary["timestamp"] as? String,
                let updateTimeStamp = readingsDictionary["update_timestamp"] as? String,
                let reading = readingsDictionary["readings"] as? NSDictionary{
                self.parseReading(readingsDict:reading)
                items = Items(timeStamp: timeStamp, updateTimeStamp: updateTimeStamp, readings: readings)
            } else {
                errorMessage += "Problem parsing trackDictionary\n"
            }
        }
        
        return items
    }
    
    fileprivate func parseReading(readingsDict: NSDictionary){
        let keys = readingsDict.allKeys as! [String]
        for keyValue in keys {
            if let reading = readingsDict[keyValue] as? NSDictionary{
                self.parseReadingItems(nameKey :keyValue, reading: reading)
            }
        }
    }
    
    fileprivate func parseReadingItems(nameKey : String, reading: NSDictionary){
        let west = reading["west"] as? Double
        let national = reading["national"] as? Double
        let east = reading["east"] as? Double
        let central = reading["central"] as? Double
        let south = reading["south"] as? Double
        let north = reading["north"] as? Double
        readings.append(Readings(name: nameKey, central: central!, east: east!, national: national!, north: north!, south: south!, west:west!))
    }
    
}
