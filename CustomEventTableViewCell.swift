//
//  CustomEventTableViewCell.swift
//  
//
//  Created by Sudikoff Lab iMac on 7/23/16.
//
//

import UIKit
import Firebase

class CustomEventTableViewCell: UITableViewCell {
    
    @IBOutlet weak var eventImage: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var startTime: UILabel!
    @IBOutlet weak var endTime: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var notes: UILabel!
    @IBOutlet weak var tags: UILabel!
    var latitude: String!
    var longitude: String!
    var idString: String!
    
    let ref = FIRDatabase.database().reference()
    
    func configureCell(event: Event) {
        // Configure the current cell
        let event = event
        
        let imageData = NSData(base64EncodedString: event.image, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)
        if imageData != "" {
            let decodedImage = UIImage(data: imageData!)!
            eventImage.image = decodedImage
        } else {
            
        }
        
        self.latitude = event.latitude
        self.longitude = event.longitude
        
        self.idString = event.idString
        
        if event.title == "" {
            self.title.text = "No Title"
        } else {
            self.title.text = event.title
        }
        if event.startTime == "" {
            self.startTime.text = "No Time"
        } else {
            self.startTime.text = event.startTime
        }
        if event.endTime == "" {
            self.endTime.text = "No Time"
        } else {
            self.endTime.text = event.startTime
        }
        if event.location == "" {
            self.location.text = "No Address"
        } else {
            self.location.text = "\(event.location)"
        }
        if event.desc == "" {
            self.notes.text = "No Description"
        } else {
            self.notes.text = "Info : \(event.desc)"
        }
        if event.tags == "" {
            self.tags.text = "No Tags"
        } else {
            self.tags.text = event.tags
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
