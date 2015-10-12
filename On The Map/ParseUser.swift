//
//  ParseUser.swift
//  On The Map
//
//  Created by Brian Quick on 10/11/15.
//  Copyright © 2015 Brian Quick. All rights reserved.
//

import Foundation

class ParseUser : NSObject {
        
    var session: NSURLSession
    
    override init() {
        session = NSURLSession.sharedSession()
        super.init()
    }

    
    
  func taskForGETMethod(className: String, queryString: String?, parameters: [String : AnyObject], completionHandler: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
    
    /* 1. Set the parameters */
    var mutableParameters = parameters
    mutableParameters[ParameterKeys.ApiKey] = Constants.ApiKey

    
    
    let urlString = Constants.ParseURL + method
    let url = NSURL(string: urlString)!
    let request = NSMutableURLRequest(URL: url)
    request.HTTPMethod = "POST"
    request.addValue("application/json", forHTTPHeaderField: "Accept")
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")

    
    }
    
    
    
}


