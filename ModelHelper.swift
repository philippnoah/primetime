//
//  ModelHelper.swift
//  Primetime
//
//  Created by Philipp Eibl on 7/23/16.
//  Copyright © 2016 Philipp Eibl. All rights reserved.
//

import Foundation

class ModelHelper {
    
    static func createUser(email: String, name: String, password: String) -> User {
        
        let user = User()
        user.email = email
        user.name = name
        user.password = password
        
        return user
    }
    
}