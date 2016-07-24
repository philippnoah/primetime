//
//  MessageTableViewCell.swift
//
//  Created by Philipp Eibl on 7/6/16.
//  Copyright © 2016 Philipp Eibl. All rights reserved.
//

import Foundation
import UIKit

protocol MessageTableViewCell {
    var content: UILabel! {get}
}

class SenderMessageTableViewCell: UITableViewCell, MessageTableViewCell {
    
    @IBOutlet var content: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

class ReceiverMessageTableViewCell: UITableViewCell, MessageTableViewCell {
    
    @IBOutlet var content: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}