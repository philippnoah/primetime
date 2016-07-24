//
//  EventsTableViewController.swift
//  PrimeTime
//
//  Created by Sudikoff Lab iMac on 7/23/16.
//  Copyright © 2016 PrimeTime. All rights reserved.
//

import UIKit
import TabPageViewController
import PageController
import Firebase
import MapKit
import CoreLocation

var events = [Event]()

var masterLatitude: String = "0"
var masterLongitude: String = "0"

class EventsTableViewController: UITableViewController, CLLocationManagerDelegate {
    
    var newImage: UIImageView = UIImageView()
    
    var locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.layoutMargins = UIEdgeInsetsZero
        tableView.separatorInset = UIEdgeInsetsZero
        
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationItem.setHidesBackButton(true, animated:true);
        UINavigationBar.appearance().barTintColor = UIColor(red: 140/255, green: 196/255, blue: 76/255, alpha: 1.0)
        let navigationHeight = navigationController?.navigationBar.frame.maxY ?? 0.0
        tableView.contentInset.top = navigationHeight + TabPageOption().tabHeight
        self.tableView.reloadData()
        
        self.refreshControl?.addTarget(self, action: #selector(EventsTableViewController.handleRefresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        loadEvents()
        
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
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        masterLatitude = String(locValue.latitude)
        masterLongitude = String(locValue.longitude)
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        
        self.locationManager.stopUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError)
    {
        print("Errors: " + error.localizedDescription)
    }
    
    func handleRefresh(refreshControl: UIRefreshControl) {
        // Do some reloading of data and update the table view's data source
        // Fetch more objects from a web service, for example...
        
        // Simply adding an object to the data source for this example
        loadEvents()
        
        self.tableView.reloadData()
        refreshControl.endRefreshing()
    }

    // Loads all the events from the database
    func loadEvents() {
        events.removeAll()
        var image: String = ""
        var title: String = ""
        var date: String = ""
        var startTime: String = ""
        var endTime: String = ""
        var location: String = ""
        var city: String = ""
        var tags: String = ""
        var noteDescription: String = ""
        var idString: String = ""
        var latitude: String = ""
        var longitude: String = ""
        var ageRange: String = ""
        var lastCount = 0
        
        let ref = FIRDatabase.database().reference().child("posts")
        events = []
        ref.observeEventType(FIRDataEventType.Value, withBlock: { (snapshot) in
            if (events.count == lastCount) {
                events = []
                lastCount = 0
            }
            if (!(snapshot.value is NSNull)) {
                let postDict = snapshot.value as? [String : AnyObject]
                for object in postDict! {
                    let obj = object.1 as! NSDictionary
                    for (key, value) in obj {
                        if (key as! String == "Image") {
                            image = value as! String
                            if (image != "") {
                                //let imageData = NSData(base64EncodedString: image as String, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)
                               //decodedImage = UIImage(data: imageData!)!
                            }
                        } else if (key as! String == "Title") {
                            title = value as! String
                        } else if (key as! String == "Location") {
                            location = value as! String
                        } else if (key as! String == "ID String") {
                            idString = value as! String
                        } else if (key as! String == "Date") {
                            date = value as! String
                        } else if (key as! String == "Latitude") {
                            latitude = value as! String
                        } else if (key as! String == "Longitude") {
                            longitude = value as! String
                        } else if (key as! String == "Description") {
                            noteDescription = value as! String
                        } else if (key as! String == "ID String") {
                            idString = value as! String
                        } else if (key as! String == "Start Time") {
                            startTime = value as! String
                        } else if (key as! String == "End Time") {
                            endTime = value as! String
                        } else if (key as! String == "City") {
                            city = value as! String
                        } else if (key as! String == "Age Range") {
                            ageRange = value as! String
                        } else if (key as! String == "Tags") {
                            tags = value as! String
                        }
                        // pulledNote for an Image Note
                        if (image != "" && title != "" && date != "" && startTime != "" && endTime != "" && idString != "" && noteDescription != "" && latitude != "" && longitude != "") {
                            let pulledEvent = Event(title: title as String, desc: noteDescription as String, startTime: startTime as String, endTime: endTime as String, date: date as String, location: location as String, image: image as String, tags: tags as String, ageRange: ageRange as String, latitude: latitude as String, longitude: longitude as String, idString: idString as String, city: city as String) as Event!
                            events as NSArray
                            events.append(pulledEvent)
                            lastCount = lastCount + 1
                            image = ""
                            title = ""
                            date = ""
                            tags = ""
                            startTime = ""
                            city = ""
                            location = ""
                            endTime = ""
                            idString = ""
                            noteDescription = ""
                            idString = ""
                            latitude = ""
                            longitude = ""
                        }
                    }
                }
                
                // Reloads the feed so all the posts can be viewed by the user
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.tableView.reloadData()
                })
            }
        })
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return events.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> CustomEventTableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("EventCell", forIndexPath: indexPath) as? CustomEventTableViewCell
        let event = events[indexPath.row]
        print("Notes length: \(events.count)")
        cell!.configureCell(event)
        tableView.rowHeight = 220.00
        self.tableView.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        cell!.backgroundColor = UIColor.whiteColor()
        
        return cell!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let indexPath: NSIndexPath = self.tableView.indexPathForSelectedRow!
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let currentCell = tableView.cellForRowAtIndexPath(indexPath)! as! CustomEventTableViewCell
        
        currentCell.layoutMargins = UIEdgeInsetsZero
        
        let event = events[indexPath.row]
        let vc = storyboard!.instantiateViewControllerWithIdentifier("EventDetail") as UIViewController
        let idStringInfo: String = currentCell.idString!
        let latitudeInfo: String = currentCell.latitude
        let longitudeInfo: String = currentCell.longitude
        
        print(idStringInfo)
        (vc as! DetailEventViewController).assignIdString(idStringInfo)
        //(vc as! DetailTakeCameraViewController).assignNewCoor(latitudeInfo, longitude: longitudeInfo)
        
        performSegueWithIdentifier("toDetailView", sender: nil)
        
        //self.navigationController?.pushViewController(vc, animated: true)
        //let DestViewController = segue.destinationViewController as! DetailTakeCameraViewController
        
        //DestViewController.assignTitle(titleInfo)
        
    }

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
