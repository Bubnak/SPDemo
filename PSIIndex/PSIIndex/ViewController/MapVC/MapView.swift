//
//  MapView.swift
//  PSIIndex
//
//  Created by Bubna Ratheesh on 16/5/18.
//  Copyright © 2018 Bubna Kbubna. All rights reserved.
//

import UIKit

import Foundation
import MapKit

class MapMarkerView: MKMarkerAnnotationView {
    
    override var annotation: MKAnnotation? {
        willSet {
            guard let mapHelper = newValue as? MapHelper else { return }
            canShowCallout = true
            calloutOffset = CGPoint(x: -5, y: 5)
            rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            
            markerTintColor = mapHelper.markerTintColor
            if let imageName = mapHelper.imageName {
                glyphImage = UIImage(named: imageName)
            } else {
                glyphImage = nil
            }
        }
    }
    
}

class MapView: MKAnnotationView {
    
    override var annotation: MKAnnotation? {
        willSet {
            guard let mapHelper = newValue as? MapHelper else {return}
            
            canShowCallout = true
            calloutOffset = CGPoint(x: -5, y: 5)
            if let imageName = mapHelper.imageName {
                image = UIImage(named: imageName)
            } else {
                image = nil
            }
            let detailLabel = UILabel()
            detailLabel.numberOfLines = 0
            detailLabel.font = detailLabel.font.withSize(12)
            detailLabel.text = mapHelper.details
            detailCalloutAccessoryView = detailLabel
        }
    }
    
}

