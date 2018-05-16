//
//  PSIService.swift
//  PSIIndex
//
//  Created by Bubna Ratheesh on 16/5/18.
//  Copyright © 2018 Bubna Kbubna. All rights reserved.
//

import UIKit

class PSIService: NSObject {
    
    typealias JSONDictionary = [String: Any]
    typealias RegionResult = ([Region]?,Items?, String) -> ()
    
    // 1
    let defaultSession = URLSession(configuration: .default)
    // 2
    var dataTask: URLSessionDataTask?
    var items : Items?
    var north :North?
    var region: [Region] = []
    var readings: [Readings] = []
   
    var errorMessage = ""

func urlSession(completion: @escaping RegionResult) {
    
    if var urlComponents = URLComponents(string: "https://api.data.gov.sg/v1/environment/psi") {
        guard let url = urlComponents.url else { return }
        // 4
        dataTask = defaultSession.dataTask(with: url) { data, response, error in
            defer { self.dataTask = nil }
            // 5
            if let error = error {
                self.errorMessage += "DataTask error: " + error.localizedDescription + "\n"
            } else if let data = data,
                let response = response as? HTTPURLResponse,
                response.statusCode == 200 {
                self.updateResults(data)
                // 6
                DispatchQueue.main.async {
                    print(self.region)
                    completion(self.region, self.items, self.errorMessage)
                }
            }
        }
        dataTask?.resume()
    }
    
    }
    
    fileprivate func updateResults(_ data: Data) {
        var response: JSONDictionary?
        region.removeAll()
        
        do {
            response = try JSONSerialization.jsonObject(with: data, options: []) as? JSONDictionary
        } catch let parseError as NSError {
            errorMessage += "JSONSerialization error: \(parseError.localizedDescription)\n"
            return
        }
        
        guard let arrayRegion = response!["region_metadata"] as? [Any] else {
            errorMessage += "Dictionary does not contain results key\n"
            return
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
       ////////////////////////////////////////////////////////////////
        
        guard let arrayReadings = response!["items"] as? [Any] else {
            errorMessage += "Dictionary does not contain results key\n"
            return
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

    

