//
//  User.swift
//  Extractor
//
//  Created by Кирилл on 2/28/16.
//  Copyright © 2016 BrainDump. All rights reserved.
//

import Foundation
import Parse

class User: PFUser {
    
    @NSManaged var fullName:    String
    @NSManaged var phoneNumber: String?
    
    override class func initialize() {
        struct Static {
            static var onceToken: dispatch_once_t = 0;
        }
        dispatch_once(&Static.onceToken, {
            self.registerSubclass()
        })
    }
}
