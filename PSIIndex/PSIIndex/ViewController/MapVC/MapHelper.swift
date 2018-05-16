//
//  MapHelper.swift
//  PSIIndex
//
//  Created by Bubna Ratheesh on 16/5/18.
//  Copyright © 2018 Bubna Kbubna. All rights reserved.
//

import Foundation
import MapKit
import Contacts

class MapHelper: NSObject, MKAnnotation {
    let title: String?
    let details: String
    var coordinate: CLLocationCoordinate2D
    
    init(title: String, details: String, discipline: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.details = details
        self.coordinate = coordinate
        
        super.init()
    }
    
    var markerTintColor: UIColor  {
       return .green
    }
    
    var imageName: String? {
        return "Flag"
    }
    
    // Annotation right callout accessory opens this mapItem in Maps app
    func mapItem() -> MKMapItem {
        let addressDict = [CNPostalAddressStreetKey: title!]
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDict)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = title
        return mapItem
    }
    
}
