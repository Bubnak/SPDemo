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
    let regionRadius: CLLocationDistance = 100000
    
    @IBOutlet weak var updatedDate: UIBarButtonItem!
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.callPSIAPI()
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
            psiService.urlSession(){ regionResult,itemResult, errorMessage in
                if let regionResult = regionResult , let itemResult = itemResult{
                    self.updateMapView(region: regionResult, item: itemResult)
                    self.updateTime(time: itemResult.updateTimeStamp)
                }
                if !errorMessage.isEmpty { print("Search error: " + errorMessage) }
            }
            print("Internet Connection Available!")
        }else{
            let alert = UIAlertController(title: "No Internet Connection!", message: "", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            print("Internet Connection not Available!")
            self.updatedDate.tintColor = UIColor.red
            self.updatedDate.title = "No internet connection!!!!!!!!!!"
        }
        
        
    }
    
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
    
    
    
    func updateTime(time: String){
        self.updatedDate.tintColor = UIColor.black
        var timestamp:NSString = time as NSString
        if time.count > 10{
            timestamp = timestamp.substring(to: 10) as NSString
        }
        self.updatedDate.title = "Last Updated: " + (timestamp as String)
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
