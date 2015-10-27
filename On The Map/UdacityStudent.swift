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
    var user  = UdacityUser()
    

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
        
        let task = session.dataTaskWithRequest(request) { data, response, error in
            /* GUARD: Was there an error? */
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
                completionHandler(result: nil, error: NSError(domain: "UdacityStudent.taskForPOSTMethod", code: 1, userInfo: [NSLocalizedDescriptionKey: errorMessage]))
                return
            }
                
            
            guard let data = data else {
                completionHandler(result: nil, error: NSError(domain: "UdacityStudent.taskForPOSTMethod", code: 2, userInfo: [NSLocalizedDescriptionKey: "No data was returned by the request!"]))
                return
            }
      
            let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5)) /* subset response data! */
            print(NSString(data: newData, encoding: NSUTF8StringEncoding))
            UdacityStudent.parseJSONWithCompletionHandler(newData, completionHandler: completionHandler)
            
            
            
        }
        
        task.resume()
        return task
        
    }
    
    
    func taskForGETMethod(method: String, completionHandler: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        let urlString = Constants.BaseURL + method
        let url = NSURL(string: urlString)!
        let request = NSURLRequest(URL: url)
        
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                completionHandler(result: nil, error: error)
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                var errorMessage: String
                if let response = response as? NSHTTPURLResponse {
                    errorMessage = "Your request returned an invalid response! Status code: \(response.statusCode)!"
                } else if let response = response {
                    errorMessage = "Your request returned an invalid response! Response: \(response)!"
                } else {
                    errorMessage = "Your request returned an invalid response!"
                }
                completionHandler(result: nil, error: NSError(domain: "UdacityStudent.taskForGETMethod", code: 1, userInfo: [NSLocalizedDescriptionKey: errorMessage]))
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                completionHandler(result: nil, error: NSError(domain: "UdacityStudent.taskForGETMethod", code: 2, userInfo: [NSLocalizedDescriptionKey: "No data was returned by the request!"]))
                return
            }
            
            let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5)) /* subset response data! */
            print(NSString(data: newData, encoding: NSUTF8StringEncoding))
            UdacityStudent.parseJSONWithCompletionHandler(newData, completionHandler: completionHandler)
        }
        
        task.resume()
        return task
    }

    
    func taskForDeleteMethod(method: String, completionHandler: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
    
        let urlString = Constants.BaseURL + method
        let url = NSURL(string: urlString)!
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "DELETE"
        var xsrfCookie : NSHTTPCookie? = nil
        
        let sharedCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name   == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
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
                completionHandler(result: nil, error: NSError(domain: "UdacityStudent.taskForDeleteMethod", code: 1, userInfo: [NSLocalizedDescriptionKey: errorMessage]))
                return
            }

            if let data = data {
                let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5)) /* subset response data! */
                print(NSString(data: newData, encoding: NSUTF8StringEncoding))
                UdacityStudent.parseJSONWithCompletionHandler(newData, completionHandler: completionHandler)
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
    
    class func subtituteKey(method: String, key: String, value: String) -> String? {
        if method.rangeOfString("<\(key)>") != nil {
            return method.stringByReplacingOccurrencesOfString("<\(key)>", withString: value)
        } else {
            return nil
        }
    }
}
