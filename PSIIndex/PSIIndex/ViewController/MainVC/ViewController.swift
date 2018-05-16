//
//  ViewController.swift
//  PSIIndex
//
//  Created by Bubna Ratheesh on 16/5/18.
//  Copyright © 2018 Bubna Kbubna. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController  {
    
    
        
    let psiService = PSIService()
    var mapHelper: [MapHelper] = []
    
    @IBOutlet weak var mapView: MKMapView!
    let regionRadius: CLLocationDistance = 100000
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        psiService.urlSession(){ regionResult,itemResult, errorMessage in
            if let regionResult = regionResult {
                self.updateMapView(region: regionResult, item: itemResult!)
            }
            if !errorMessage.isEmpty { print("Search error: " + errorMessage) }
        }
    }
    
     // MARK: - Helper methods
    func updateMapView(region:[Region], item:Items) {
        mapView.delegate = self
        mapView.register(MapView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        loadInitialData(region: region, item: item)
        mapView.addAnnotations(mapHelper)
    }
    
    
    func loadInitialData(region:[Region], item:Items) {
        for regionValue in region {
            print(regionValue.latitude)
            print(regionValue.longitude)
            print(regionValue.name)
            let coordinate = CLLocationCoordinate2D(latitude: regionValue.latitude, longitude: regionValue.longitude)
            var details: String = ""
            for readingValue in item.readings{
                var doubleToString = ""
                if("north" == regionValue.name){
                     doubleToString = String(readingValue.north)
                }else if("south" == regionValue.name){
                     doubleToString = String(readingValue.south)
                }else if("east" == regionValue.name){
                     doubleToString = String(readingValue.east)
                }else if("west" == regionValue.name){
                     doubleToString = String(readingValue.west)
                }else if("central" == regionValue.name){
                     doubleToString = String(readingValue.central)
                }
                 details = details + readingValue.name + " : " + doubleToString + "\n"
            }
            mapHelper.append(MapHelper(title: "Readings : " + regionValue.name, details: details, discipline: "", coordinate: coordinate))
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}


extension ViewController: MKMapViewDelegate {
        func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView,
                 calloutAccessoryControlTapped control: UIControl) {
        let location = view.annotation as! MapHelper
        let launchOptions = [MKLaunchOptionsDirectionsModeKey:
            MKLaunchOptionsDirectionsModeDriving]
        location.mapItem().openInMaps(launchOptions: launchOptions)
    }
    
}
