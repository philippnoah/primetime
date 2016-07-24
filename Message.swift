//
//  Message.swift
//  Primetime
//
//  Created by Philipp Eibl on 7/24/16.
//  Copyright © 2016 Philipp Eibl. All rights reserved.
//

import Foundation
import UIKit

class Message {
    
    let sender: String!
    let timeStamp: NSDate!
    let content: String!
    
    init(sender: String, timeStamp: NSDate, content: String) {
        
        self.sender = sender
        self.timeStamp = timeStamp
        self.content = content
        
    }
}