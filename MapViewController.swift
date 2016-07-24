//
//  MapViewController.swift
//  PrimeTime
//
//  Created by Ray Zhu on 23/07/2016.
//  Copyright © 2016 Ray Zhu. All rights reserved.
//

import UIKit
import GoogleMaps

class MapViewController: UIViewController, GMSMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var viewMap: GMSMapView!
    var locationManager = CLLocationManager()
    var didFindMyLocation = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //requests for location services access
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        //observer for location
        viewMap.addObserver(self, forKeyPath: "myLocation", options: NSKeyValueObservingOptions.New, context: nil)
        //how to set a marker
//        let marker = GMSMarker()
//        marker.position = CLLocationCoordinate2DMake(37.77, -122.41)
//        marker.title = "San Francisco"
//        marker.snippet = "California"
//        marker.map = self.viewMap
        viewMap.delegate = self
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
        return true
    }
    //performs segue when the info above the pin is tapped
    func mapView(mapView: GMSMapView, didTapInfoWindowOfMarker marker: GMSMarker) {
//        print("info tapped")
//        performSegueWithIdentifier("infoSegue", sender: self)
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
