//
//  Node.swift
//  Extractor
//
//  Created by Кирилл on 2/27/16.
//  Copyright © 2016 BrainDump. All rights reserved.
//

import Foundation
import Parse

class Node: PFObject, PFSubclassing {
    @NSManaged var parent: PFObject?
    @NSManaged var depth:  Int
    
    @NSManaged var rating:           Int
    @NSManaged var reservedChildren: Int
    
    @NSManaged var owner:   PFUser
    @NSManaged var content: String
    
    override class func initialize() {
        struct Static {
            static var onceToken: dispatch_once_t = 0;
        }
        dispatch_once(&Static.onceToken, {
            self.registerSubclass()
        })
    }
    
    static func parseClassName() -> String {
        return "Node"
    }
}
