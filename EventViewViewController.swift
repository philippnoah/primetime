//
//  EventViewViewController.swift
//  Primetime
//
//  Created by Philipp Eibl on 7/24/16.
//  Copyright © 2016 Philipp Eibl. All rights reserved.
//

import Foundation
import Firebase
import UIKit

class EventViewViewController: UIViewController {
    
// OUTLETS
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var eventTitleLabel: UILabel!
    @IBOutlet var locationButton: UIButton!
    @IBOutlet var descriptionTextView: UITextView!
    @IBOutlet var startingTimeLabel: UILabel!
    @IBOutlet var endingTimeLabel: UILabel!
    @IBOutlet var tagLabel: UILabel!
    @IBOutlet var chatButton: UIButton!
    
// VARIABLES
    var ref: FIRDatabaseReference!
    var image: UIImage!
    var eventTitle: String!
    var eventDescription: String!
    var startingTime: String!
    var endingTime: String!
    var eventLocation: String!
    var tag: String!
    var listOfEvents: [Event] = []
    
// FUNCTIONS
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ref = FIRDatabase.database().reference()
        getAdditionalInformation()
    }
    
    func getAdditionalInformation() {
        // get any info that has not been loaded ffor the feed
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "goTolocation" {
            
        } else if segue.identifier == "goToChat" {
            
            let eventGroupChatViewController = segue.destinationViewController as! EventGroupChatViewController
            
            
        } else if segue.identifier == "back" {
            
        }
    }
    
}