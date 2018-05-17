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
    let regionRadius: CLLocationDistance = 28000
    
    @IBOutlet weak var updatedDate: UIBarButtonItem!
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let initialLocation = CLLocation(latitude: 1.35735, longitude: 103.82)
        centerMapOnLocation(location: initialLocation)
        //self.callPSIAPI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.callPSIAPI()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - ButtonAction
    @IBAction func refreshBtnClick(_ sender: Any) {
        self.callPSIAPI()
    }
    
    
    // MARK: - Helper methods
    func callPSIAPI(){
        if Reachability.isConnectedToNetwork(){
            self.updatedDate.tintColor = UIColor.black
            psiService.urlSession(){ regionResult,itemResult, errorMessage in
                if let regionResult = regionResult , let itemResult = itemResult{
                    self.updateMapView(region: regionResult, item: itemResult)
                    self.updateTime(time: itemResult.updateTimeStamp)
                }
                if !errorMessage.isEmpty { self.showAlert(title: "Error: No Data") }
            }
        }else{
            
            self.updatedDate.tintColor = UIColor.red
            self.updatedDate.title = "No internet connection!!!!!!!!!!"
            self.showAlert(title: "No Internet Connection!")
        }
        
        
    }
    func showAlert(title:String)  {
        let alert = UIAlertController(title:title, message: "", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func updateMapView(region:[Region], item:Items) {
        mapView.delegate = self
        mapView.register(MapView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        loadInitialData(region: region, item: item)
        mapView.addAnnotations(mapHelper)
    }
    
    func loadInitialData(region:[Region], item:Items) {
        for regionValue in region {
            let coordinate = CLLocationCoordinate2D(latitude: regionValue.latitude, longitude: regionValue.longitude)
            var details: String = ""
            for readingValue in item.readings{
                var doubleToString = ""
                switch regionValue.name {
                case "north":
                    doubleToString = String(readingValue.north)
                case "south":
                    doubleToString = String(readingValue.south)
                case "east":
                    doubleToString = String(readingValue.east)
                case "west":
                    doubleToString = String(readingValue.west)
                case "central":
                    doubleToString = String(readingValue.central)
                default: break
                    
                }
                details = details + readingValue.name + " : " + doubleToString + "\n"
            }
            mapHelper.append(MapHelper(title: "Readings : " + regionValue.name, details: details, discipline: "", coordinate: coordinate))
        }
    }
    
    
    func updateTime(time: String){
        var timestamp:NSString = time as NSString
        if time.count > 10{
            timestamp = timestamp.substring(to: 10) as NSString
        }
        self.updatedDate.title = "Last Updated: " + (timestamp as String)
    }
    
    func centerMapOnLocation(location: CLLocation) {
        print(regionRadius)
        print(location.coordinate.longitude)
        print(location.coordinate.latitude)
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius, regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
}



// MARK: - extenion
extension ViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView,
                 calloutAccessoryControlTapped control: UIControl) {
        let location = view.annotation as! MapHelper
        let launchOptions = [MKLaunchOptionsDirectionsModeKey:
            MKLaunchOptionsDirectionsModeDriving]
        location.mapItem().openInMaps(launchOptions: launchOptions)
    }
    
}

