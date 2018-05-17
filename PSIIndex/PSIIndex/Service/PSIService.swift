//
//  PSIService.swift
//  PSIIndex
//
//  Created by Bubna Ratheesh on 16/5/18.
//  Copyright © 2018 Bubna Kbubna. All rights reserved.
//

import UIKit

class PSIService: NSObject {
    
    let psiURL = "https://api.data.gov.sg/v1/environment/psi"
    
    typealias JSONDictionary = [String: Any]
    typealias Result = ([Region]?,Items?, String) -> ()
    
    // 1
    let defaultSession = URLSession(configuration: .default)
    // 2
    var dataTask: URLSessionDataTask?
    var items : Items?
    var north :North?
    var region: [Region] = []
    var readings: [Readings] = []
   
    var errorMessage = ""

func urlSession(completion: @escaping Result) {
    
    if var urlComponents = URLComponents(string: psiURL) {
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
        let psiPaser = PSIParser()
        
        items = psiPaser.parseItemResults(response: response!)
        region = psiPaser.parseRegionResults(regionResponse: response!)
    }
    
    
}

    

