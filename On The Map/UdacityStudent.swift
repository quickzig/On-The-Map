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
    
    
    
    func taskForPOSTMethod(method: String, jsonBody: [String:AnyObject], completionHandler: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {


        let urlString = Constants.BaseURL + method
        let url = NSURL(string: urlString)!
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        do {
            request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(jsonBody, options: NSJSONWritingOptions())
        }
        catch let error as NSError {
            print("A JSON parsing error occurred, here are the details:\n \(error)")
        }
        
        let task = session.dataTaskWithRequest(request) { data, response, downloadError in
            if let error = downloadError {
                completionHandler(result: nil, error: error)
            } else {
                if let data = data {
                    UdacityStudent.parseJSONWithCompletionHandler(data, completionHandler: completionHandler)
                }
            }
        }
        
        task.resume()
        return task
        
    }
    
    class func parseJSONWithCompletionHandler(data: NSData, completionHandler: (result: AnyObject!, error: NSError?) -> Void) {
        
        var parsedResult: AnyObject!
        do {
            parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandler(result: nil, error: NSError(domain: "parseJSONWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        
        completionHandler(result: parsedResult, error: nil)
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
