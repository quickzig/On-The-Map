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

    /// Get Student Locations
    func taskForGETMethod(method: String, queryString: String?, parameters: [String : AnyObject], completionHandler: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        let urlString = Constants.ParseURL + method
        let url = NSURL(string: urlString)!
        let request = NSMutableURLRequest(URL: url)
        request.addValue(Constants.ParseApplicationID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(Constants.RESTAPIKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            var errorMessage: String
            guard (error == nil) else {
                errorMessage = "There was an error with your request: \(error?.description)"
                completionHandler(result: nil, error: NSError(domain: "ParseUser.taskForGETMethod", code: 1, userInfo: [NSLocalizedDescriptionKey: errorMessage]))
                return
            }
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                
                if let response = response as? NSHTTPURLResponse {
                     errorMessage = "Your request returned an invalid response! Status code: \(response.statusCode)!"
                } else if let response = response {
                     errorMessage = "Your request returned an invalid response! Response: \(response)!"
                } else {
                     errorMessage = "Your request returned an invalid response!"
                }
                completionHandler(result: nil, error: NSError(domain: "ParseUser.taskForGETMethod", code: 1, userInfo: [NSLocalizedDescriptionKey: errorMessage]))
                return
            }
            guard let data = data else {
                print("No data was returned by the request!")
                return
            }
            ParseUser.parseJSONWithCompletionHandler(data, completionHandler: completionHandler)
        }
        task.resume()
       return task
    }
    
    
    ///Post a Student Location
    func taskForPOSTMethod(method: String, jsonBody: [String:AnyObject], completionHandler: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        let urlString = Constants.ParseURL + method
        let url = NSURL(string: urlString)!
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(Constants.ParseApplicationID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(Constants.RESTAPIKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        do {
            request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(jsonBody, options: NSJSONWritingOptions())
        }
        catch let error as NSError {
            print("A JSON parsing error occurred, here are the details:\n \(error)")
        }
        
        let task = session.dataTaskWithRequest(request) { data, response, error in
            guard (error == nil) else {
                completionHandler(result: nil, error: error)
                return
            }
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                var errorMessage: String
                if let response = response as? NSHTTPURLResponse {
                    errorMessage = "Your request returned an invalid response! Status code: \(response.statusCode)!"
                } else if let response = response {
                    errorMessage = "Your request returned an invalid response! Response: \(response)!"
                } else {
                    errorMessage = "Your request returned an invalid response!"
                }
                completionHandler(result: nil, error: NSError(domain: "ParseUser.taskForPOSTMethod", code: 1, userInfo: [NSLocalizedDescriptionKey: errorMessage]))
                return
            }
            if let data = data {
               UdacityStudent.parseJSONWithCompletionHandler(data, completionHandler: completionHandler)
            }
        }
        task.resume()
        return task
    }

    
    
    ///Parse the JSON data
    class func parseJSONWithCompletionHandler(data: NSData, completionHandler: (result: AnyObject!, error: NSError?) -> Void) {
        var parsedResult: AnyObject? = nil
        do {
            parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments)
        }
        catch let error as NSError {
            completionHandler(result: nil, error: error)
        }
        completionHandler(result: parsedResult, error: nil)
    }
    
    class func sharedInstance() -> ParseUser {
        struct Singleton {
            static var sharedInstance = ParseUser()
        }
        return Singleton.sharedInstance
    }
}


