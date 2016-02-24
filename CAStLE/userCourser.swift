//
//  userCourser.swift
//  CAStLE
//
//  Created by Rafi Rizwan on 2/21/16.
//  Copyright © 2016 Firesquad. All rights reserved.
//

import UIKit
import Parse

class userCourser: NSObject {
    static let sharedInstance = userCourser()
    var classes = [PFObject]()
    var classesUnconfirmed = [PFObject]()
    var user:PFUser!
    private override init() {
        
    }
}
