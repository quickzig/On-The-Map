//
//  UdacityUser.swift
//  On The Map
//
//  Created by Brian Quick on 10/6/15.
//  Copyright © 2015 Brian Quick. All rights reserved.
//

struct UdacityUser {
    
    var userKey: String?  = nil
    
    var firstName: String? = nil
    var lastName: String? = nil
    
    var fullName: String {
        get {
            if firstName != nil && lastName != nil {
                return firstName! + " " + lastName!
            } else {
                return ""
            }
        }
    }
    
    init() {
        firstName = ""
        lastName = ""
        userKey = ""
    }

}


