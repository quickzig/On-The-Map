//
//  UdacityStudent.swift
//  On The Map
//
//  Created by Brian Quick on 10/4/15.
//  Copyright © 2015 Brian Quick. All rights reserved.
//

import Foundation

class UdacityStudent : NSObject {
    
    /* Shared session */
    var session: NSURLSession
    
    /* Authentication state */
    var sessionID : String? = nil
    
    
    

    override init() {
        session = NSURLSession.sharedSession()
        super.init()
    }
    
    
    
    func taskForGETMethod(method: String, parameters: [String : AnyObject], completionHandler: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
    
    }
    
}
