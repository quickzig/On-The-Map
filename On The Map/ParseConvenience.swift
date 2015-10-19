//
//  ParseConvenience.swift
//  On The Map
//
//  Created by Brian Quick on 10/11/15.
//  Copyright © 2015 Brian Quick. All rights reserved.
//

import Foundation

extension ParseUser {

    
func getStudentLocations(completionHandler: (result: [ParseStudentLocation]?, error: NSError?) -> Void){
    
    let parameters: [String: AnyObject] = [ParseUser.ParameterKeys.Limit : ParseUser.Constants.Limit, ParseUser.ParameterKeys.Order: ParseUser.Constants.RecentlyUpdated]
    
    taskForGETMethod(Methods.StudentLocation, queryString: nil, parameters: parameters) { JSONResult, error in
        
        if let error = error {
            completionHandler(result: nil, error: error)
        } else {
            
            if let results = JSONResult.valueForKey(JSONResponseKeys.Results) as? [[String: AnyObject]] {
                    let studentLocations = ParseStudentLocation.studentLocationsFromResults(results)
                     completionHandler(result: studentLocations, error: nil)
                 } else {
                     completionHandler(result: nil, error: NSError(domain: Methods.StudentLocation, code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not get student locations"]))
        }
    }
    
    // completionHandler(result: nil,error: nil)
    }
    }
}