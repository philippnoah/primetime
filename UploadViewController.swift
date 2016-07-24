//
//  UploadViewController.swift
//  PrimeTime
//
//  Created by Sudikoff Lab iMac on 7/23/16.
//  Copyright © 2016 PrimeTime. All rights reserved.
//

import UIKit
import ImagePicker
import Firebase
import MapKit
import CoreLocation

class UploadViewController: UIViewController, ImagePickerDelegate, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var eventTitle: UITextField!
    @IBOutlet weak var eventLocation: UITextField!
    @IBOutlet weak var startingTime: UITextField!
    @IBOutlet weak var endingTime: UITextField!
    @IBOutlet weak var eventDescription: UITextView!
    @IBOutlet weak var eventTags: UITextField!
    @IBOutlet weak var eventAgeRange: UITextField!
    var mapView: MKMapView = MKMapView()
    
    let ref = FIRDatabase.database().reference()
    
    let locationManager = CLLocationManager()
    
    var latitude: String = "0"
    var longitude: String = "0"
    
    var imageData: NSData = NSData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mapView.delegate = self

        // Do any additional setup after loading the view.
        
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    // MARK: - Location Delegate Methods
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        self.latitude = String(locValue.latitude)
        self.longitude = String(locValue.longitude)
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        
        let location = locations.last
        
        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1))
        
        self.mapView.setRegion(region, animated: true)
        
        self.locationManager.stopUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError)
    {
        print("Errors: " + error.localizedDescription)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Opens the camera picker
    @IBAction func openCamera(send: AnyObject?) {
        let imagePickerController = ImagePickerController()
        imagePickerController.imageLimit = 1
        Configuration.doneButtonTitle = "Save"
        Configuration.noImagesTitle = "Sorry! There are no images here!"
        imagePickerController.delegate = self
        presentViewController(imagePickerController, animated: true, completion: nil)
    }
    
    // Function called when user selects wrapper image
    func wrapperDidPress( images: [UIImage]) {
        print("Wrapper Did Press")
    }
    
    // Function called when user selects the done button
    func doneButtonDidPress(images: [UIImage]) {
        print("Done Button Did Press")
        // Might not have the images
        imageView.image = images[0]
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    // Function called when the suer selects the cancel button
    func cancelButtonDidPress() {
        print("Cancel Button Did Press")
    }
    
    @IBAction func shareEvent(send: AnyObject?) {
        
        var saveTitle: String!
        var saveDesc: String!
        var saveStartTime: String!
        var saveEndTime: String!
        var saveLocation: String!
        var saveTags: String!
        var saveAgeRange: String!
        let base64String: String!
        let idString = NSUUID().UUIDString
        
        var finalTime : String = ""
        var finalDate : String = ""
        
        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let componentsHour = calendar.components(.Hour, fromDate: date)
        var hour = componentsHour.hour
        let componentsMin = calendar.components(.Minute, fromDate: date)
        let minute = componentsMin.minute
        var dayPortion : String = "AM"
        if (hour > 12) {
            hour = hour - 12
            dayPortion = "PM"
        } else if (hour <= 12) {
            dayPortion = "AM"
        }
        
        let requestedComponents: NSCalendarUnit = [
            NSCalendarUnit.Year,
            NSCalendarUnit.Month,
            NSCalendarUnit.Day,
            NSCalendarUnit.Hour,
            NSCalendarUnit.Minute,
            NSCalendarUnit.Second
        ]
        let dateTimeComponents = calendar.components(requestedComponents, fromDate: date)
        if (minute < 10) {
            finalTime = "\(hour):0\(minute) \(dayPortion)"
        } else {
            finalTime = "\(hour):\(minute) \(dayPortion)"
        }
        print(finalTime)
        
        if (dateTimeComponents.month == 1) {
            finalDate = finalDate + "January"
        } else if (dateTimeComponents.month == 2) {
            finalDate = finalDate + "February"
        } else if (dateTimeComponents.month == 3) {
            finalDate = finalDate + "March"
        } else if (dateTimeComponents.month == 4) {
            finalDate = finalDate + "April"
        } else if (dateTimeComponents.month == 5) {
            finalDate = finalDate + "May"
        } else if (dateTimeComponents.month == 6) {
            finalDate = finalDate + "June"
        } else if (dateTimeComponents.month == 7) {
            finalDate = finalDate + "July"
        } else if (dateTimeComponents.month == 8) {
            finalDate = finalDate + "August"
        } else if (dateTimeComponents.month == 9) {
            finalDate = finalDate + "September"
        } else if (dateTimeComponents.month == 10) {
            finalDate = finalDate + "October"
        } else if (dateTimeComponents.month == 11) {
            finalDate = finalDate + "November"
        } else if (dateTimeComponents.month == 12) {
            finalDate = finalDate + "December"
        }
        finalDate = finalDate + " \(dateTimeComponents.day), \(dateTimeComponents.year)"
        print(finalDate)
        
        if eventTitle.text?.isEmpty == true {
            saveTitle = ""
        } else {
            saveTitle = eventTitle.text
        }
        
        if eventDescription.text?.isEmpty == true {
            saveDesc = ""
        } else {
            saveDesc = eventDescription.text
        }
        
        if startingTime.text?.isEmpty == true {
            saveStartTime = ""
        } else {
            saveStartTime = startingTime.text
        }
        
        if endingTime.text?.isEmpty == true {
            saveEndTime = ""
        } else {
            saveEndTime = endingTime.text
        }
        
        if eventLocation.text?.isEmpty == true {
            saveLocation = ""
        } else {
            saveLocation = eventLocation.text
        }
        
        if imageView == nil || imageView.image == nil {
            base64String = ""
        } else {
            // Translate the image into string code to save in Firebase
            self.imageData = UIImageJPEGRepresentation(imageView.image!, 0.1)!
            base64String = imageData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
        }
        
        if eventTags.text?.isEmpty == true {
            saveTags = ""
        } else {
            saveTags = eventTags.text
        }
        
        if eventAgeRange.text?.isEmpty == true {
            saveAgeRange = ""
        } else {
            saveAgeRange = eventAgeRange.text
        }
        
       
        /* Check the following
         *
         * Title
         * Location
         * Description
         * Start Time
         * End Time
         * Age Range
         * Latitude
         * Longitude
         *
         */
        
        self.self.getPlaceCity(Double(self.latitude)!, longitude: Double(self.longitude)!, completion: {(answer: String?) -> Void in
            
            print("Answer: \(answer)")
            
            let eventNote : Event = Event(title: saveTitle, desc: saveDesc, startTime: saveStartTime, endTime: saveEndTime, date: finalDate, location: saveLocation, image: base64String, tags: saveTags, ageRange: saveAgeRange, latitude: self.latitude, longitude: self.longitude, idString: idString, city: answer!)
            
            // Uploading the event post to the 'posts' section in the Firebase database
            self.ref.child("posts").observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                if (!(snapshot.value is NSNull)) {
                    self.ref.child("posts").child(eventNote.getIdString()).setValue(eventNote.toArray())
                } else {
                    self.ref.child("posts").child(eventNote.getIdString()).setValue(eventNote.toArray())
                }
            })
            
        })
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
