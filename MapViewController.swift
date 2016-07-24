//
//  MapViewController.swift
//  PrimeTime
//
//  Created by Ray Zhu on 23/07/2016.
//  Copyright © 2016 Ray Zhu. All rights reserved.
//

import UIKit
import GoogleMaps
import MapKit
import CoreLocation

class MapViewController: UIViewController, GMSMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var viewMap: GMSMapView!
    var locationManager = CLLocationManager()
    var didFindMyLocation = false
    
    var latitude: String!
    var longitude: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //requests for location services access
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        //observer for location
        viewMap.addObserver(self, forKeyPath: "myLocation", options: NSKeyValueObservingOptions.New, context: nil)

        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        self.self.getPlaceCity(Double(masterLatitude)!, longitude: Double(masterLongitude)!, completion: {(answer: String?) -> Void in
            // answer is equal to the city at the given coordinates
            // how to set a marker
            if events.isEmpty == false {
                for (var i = 0; i < events.count; i = i + 1) {
                    print("List city: \(events[i].city)")
                    if events[i].city == answer {
                        print(answer!)
                        let marker = GMSMarker()
                        marker.position = CLLocationCoordinate2DMake(Double(events[i].latitude)!, Double(events[i].longitude)!)
                        marker.title = "\(events[i].title)"
                        marker.snippet = "\(events[i].location)"
                        marker.map = self.viewMap
                        self.viewMap.delegate = self
                    }
                }
            } else {
                
            }
            
        })
    }
    
    // MARK: - Location Delegate Methods
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        self.latitude = String(locValue.latitude)
        self.longitude = String(locValue.longitude)
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        
        self.locationManager.stopUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError)
    {
        print("Errors: " + error.localizedDescription)
    }
    
    func getPlaceCity(latitude: Double, longitude: Double, completion: (answer: String?) -> Void) {
        
        let coordinates = CLLocation(latitude: latitude, longitude: longitude)
        
        CLGeocoder().reverseGeocodeLocation(coordinates, completionHandler: {(placemarks, error) -> Void in
            if (error != nil) {
                print("Reverse geocoder failed with an error" + error!.localizedDescription)
                completion(answer: "")
            } else if placemarks!.count > 0 {
                var placeMark: CLPlacemark!
                placeMark = placemarks?[0]
                completion(answer: placeMark.addressDictionary!["City"] as? String)
            } else {
                print("Problems with the data received from geocoder.")
                completion(answer: "")
            }
        })
        
    }
    
    //function which enables location use when the user presses allow location services
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.AuthorizedWhenInUse {
            viewMap.myLocationEnabled = true
        }
    }
    //function which moves camera when the location is found
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if !didFindMyLocation {
            let myLocation: CLLocation = change![NSKeyValueChangeNewKey] as! CLLocation
            viewMap.camera = GMSCameraPosition.cameraWithTarget(myLocation.coordinate, zoom: 15.5)
            viewMap.settings.myLocationButton = true
            didFindMyLocation = true
        }
    }
    //moves the camera and zooms in to the pin when the pin is tapped
    func mapView(mapView: GMSMapView, didTapMarker marker: GMSMarker) -> Bool {
        viewMap.camera = GMSCameraPosition.cameraWithTarget(marker.position, zoom: 17.0)
        return false
    }
    //performs segue when the info above the pin is tapped
    func mapView(mapView: GMSMapView, didTapInfoWindowOfMarker marker: GMSMarker) {
        print("info tapped")
        performSegueWithIdentifier("fromMapToDetail", sender: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
