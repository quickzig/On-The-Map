//
//  UdacityConvenience.swift
//  On The Map
//
//  Created by Brian Quick on 10/5/15.
//  Copyright © 2015 Brian Quick. All rights reserved.
//

import UIKit
import Foundation

extension UdacityStudent {


    func getSessionID(username: String, password: String, completionHandler: (success: Bool, errorString: String?) -> Void) {
        
        
        let jsonBody : [String:AnyObject] = [
            JSONBodyKeys.UdacityCredentials: [
                JSONBodyKeys.Username : username,
                JSONBodyKeys.Password : password
            ]
        ]
        
        taskForPOSTMethod(Methods.Session, jsonBody: jsonBody) { JSONResult, error in
            
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                print(error)
                completionHandler(success: false,errorString: "Login Failed (Session ID).")
            } else {
                
                //Get account key info
                if let accountDictionary = JSONResult[JSONResponseKeys.Account] as? NSDictionary {
                    if let userKey = accountDictionary[JSONResponseKeys.UserKey] as? String {
                        self.user.userKey = userKey
                    } else {
                        print("Could not find \(JSONResponseKeys.UserKey) in \(accountDictionary)")
                    }
                } else {
                    print("Could not find \(JSONResponseKeys.Account) in \(JSONResult)")
                }
                
                //Get session Info
                if let sessionDictionary = JSONResult[JSONResponseKeys.Session] as? NSDictionary {
                    if let sessionID = sessionDictionary[JSONResponseKeys.SessionID] as? String {
                        self.sessionID = sessionID
                    } else {
                        print("Could not find \(JSONResponseKeys.SessionID) in \(sessionDictionary)")
                    }
                } else {
                    print("Could not find \(JSONResponseKeys.Session) in \(JSONResult)")
                }
                
                
                if self.user.userKey != nil && self.sessionID != nil {
                    completionHandler(success: true,  errorString: nil)
                } else
                {
                    completionHandler(success: false, errorString: "Login Failed (Session ID).")
                }
                
                
                
                
            }
            
        }
        
    }
        func authenticateStudentWithUdacity(username: String, password: String, completionHandler: (success: Bool, error: NSError?) -> Void) {
            
            self.getSessionID(username, password: password) { (success, errorString) in
                if success {
                    print(self.sessionID)
                    
                } else {
                    //completionHandler(success: success, errorString: errorString)
                }
            }
        }
    
}
