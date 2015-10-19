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
   // var parseStudentLocation = ParseStudentLocation()
    
    override init() {
        session = NSURLSession.sharedSession()
        super.init()
    }
    
    
    

    
    
    func taskForGETMethod(method: String, queryString: String?, parameters: [String : AnyObject], completionHandler: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        let urlString = Constants.ParseURL + method
        let url = NSURL(string: urlString)!
        
        
        let request = NSMutableURLRequest(URL: url)
        request.addValue(Constants.ParseApplicationID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(Constants.RESTAPIKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            
            guard (error == nil) else {
                print("There was an error with your request: \(error)")
                return
            }
            
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                if let response = response as? NSHTTPURLResponse {
                    print("Your request returned an invalid response! Status code: \(response.statusCode)!")
                } else if let response = response {
                    print("Your request returned an invalid response! Response: \(response)!")
                } else {
                    print("Your request returned an invalid response!")
                }
                return
            }
            
            guard let data = data else {
                print("No data was returned by the request!")
                return
            }
            
            ParseUser.parseJSONWithCompletionHandler(data, completionHandler: completionHandler)

           //print(NSString(data: data!, encoding: NSUTF8StringEncoding))
        }
        
        task.resume()
       return task
        
    }
    
    
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
    
    // MARK: Singleton
    
    class func sharedInstance() -> ParseUser {
        struct Singleton {
            static var sharedInstance = ParseUser()
        }
        return Singleton.sharedInstance
    }

    
}


