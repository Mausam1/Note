//
//  LocationVC.swift
//  Note
//
//  Created by Mausam on 7/11/17.
//  Copyright © 2017 Mausam. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class LocationVC: UIViewController,CLLocationManagerDelegate {
    
    var isNewNote:Bool!
    var locationManager = CLLocationManager()
    
    let newPin = MKPointAnnotation()
    var location:String?
    
    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        if isNewNote{
            getCurrentLocation()
        }
        else{
            let locationArray = location?.characters.split{$0 == " "}.map(String.init)
            print("lat : \(String(describing: locationArray?[0])) long: \(String(describing: locationArray?[1]))")
            let lattitude = Double((locationArray?[0])!)
            let longitude = Double((locationArray?[1])!)
            
            let currentLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(lattitude! , longitude!)
            let viewRegion = MKCoordinateRegion(center: currentLocation, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            mapView.setRegion(viewRegion, animated: true)
            newPin.coordinate = CLLocation(latitude: currentLocation.latitude, longitude: currentLocation.longitude).coordinate
            mapView.addAnnotation(newPin)
        }
        
        // Do any additional setup after loading the view.
    }
    
    func getCurrentLocation() {
        if (CLLocationManager.locationServicesEnabled()) {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.requestWhenInUseAuthorization()
        }
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
        let noLocation = CLLocationCoordinate2D()
        let viewRegion = MKCoordinateRegion(center: noLocation, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        mapView.setRegion(viewRegion, animated: false)
    }
    
    
    //MARK: - LocationManager delegate
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        mapView.removeAnnotation(newPin)
        let currentLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(locations.last!.coordinate.latitude, locations.last!.coordinate.longitude)
        print("current location: latitude: \(String(describing: locations.last?.coordinate.latitude)), longitude: \(String(describing: locations.last?.coordinate.longitude))")
        let viewRegion = MKCoordinateRegion(center: currentLocation, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        mapView.setRegion(viewRegion, animated: true)
        newPin.coordinate = (locations.last?.coordinate)!
        mapView.addAnnotation(newPin)
        appDelegate.currentNote?.location = "\((String(describing: locations.last!.coordinate.latitude))) \(String(describing: locations.last!.coordinate.longitude))"
    }
    
    
    deinit {
        print("\(self) deinit")
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
