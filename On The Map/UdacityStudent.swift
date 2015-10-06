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
    
    
    
    func taskForPOSTMethod(method: String, parameters: [String : AnyObject], jsonBody: [String:AnyObject], completionHandler: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {

        
        
        let urlString = Constants.BaseURL + method
        let url = NSURL(string: urlString)!
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            
            if error != nil { // Handle error…
                return
            }
       //     let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5)) /* subset response data! */
        //    println(NSString(data: newData, encoding: NSUTF8StringEncoding))
            
        }
        task.resume()
        
        return task
        
    }
    
    
    
    
    
    
    /* Helper function: Given a dictionary of parameters, convert to a string for a url */
    class func escapedParameters(parameters: [String : AnyObject]) -> String {
        
        var urlVars = [String]()
        
        for (key, value) in parameters {
            
            /* Make sure that it is a string value */
            let stringValue = "\(value)"
            
            /* Escape it */
            let escapedValue = stringValue.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
            
            /* Append it */
            urlVars += [key + "=" + "\(escapedValue!)"]
            
        }
        
        return (!urlVars.isEmpty ? "?" : "") + urlVars.joinWithSeparator("&")
    }
    
    class func sharedInstance() -> UdacityStudent {
        
        struct Singleton {
            static var sharedInstance = UdacityStudent()
        }
        
        return Singleton.sharedInstance
    }

    
}
