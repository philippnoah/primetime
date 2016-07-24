//
//  UIOverrides.swift
//  Primetime
//
//  Created by Philipp Eibl on 7/24/16.
//  Copyright © 2016 Philipp Eibl. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable class MessageBubble: UIView {
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 8
    }
}

@IBDesignable class LoginView: UIView {
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 5
    }
}