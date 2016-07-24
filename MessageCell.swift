//
//  Message.swift
//  Primetime
//
//  Created by Philipp Eibl on 7/24/16.
//  Copyright © 2016 Philipp Eibl. All rights reserved.
//

import Foundation
import UIKit

protocol MessageTableViewCell {
    var content: UILabel! {get}
    var byUserLabel: UILabel! {get}
}

class ReceivedMessageCell: UITableViewCell, MessageTableViewCell {
    
    @IBOutlet var byUserLabel: UILabel!
    @IBOutlet var messageBubble: UIView!
    @IBOutlet var content: UILabel!
}

class SentMessageCell: UITableViewCell, MessageTableViewCell {
    
    @IBOutlet var byUserLabel: UILabel!
    @IBOutlet var messageBubble: UIView!
    @IBOutlet var content: UILabel!
}