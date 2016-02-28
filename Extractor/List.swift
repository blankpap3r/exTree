//
//  List.swift
//  Extractor
//
//  Created by Кирилл on 2/27/16.
//  Copyright © 2016 BrainDump. All rights reserved.
//

import Foundation
import Parse

class List: PFObject, PFSubclassing {
    
    @NSManaged var lastNode: PFObject
    
    @NSManaged var rating:                Int
    @NSManaged var contributersSearchStr: String
    
    override class func initialize() {
        struct Static {
            static var onceToken: dispatch_once_t = 0;
        }
        dispatch_once(&Static.onceToken, {
            self.registerSubclass()
        })
    }
    
    class func parseClassName() -> String {
        return "List"
    }
}
