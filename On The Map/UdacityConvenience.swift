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
            guard (error == nil) else {
                print(error)
                completionHandler(success: false, errorString: error!.description)
                return
            }
            
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
                completionHandler(success: false, errorString: "Invalid credentials")
            }
            
        }
        
    }
    
    func deleteSession(completionHandler: (success: Bool, errorString: String?) -> Void){
       
        taskForDeleteMethod(Methods.Session) { JSONResult, error in
            guard (error == nil) else {
                print(error)
                completionHandler(success: false, errorString: error!.description)
                return
            }
            
            //Get session Info
            if let sessionDictionary = JSONResult[JSONResponseKeys.Session] as? NSDictionary {
                if let sessionID = sessionDictionary[JSONResponseKeys.SessionID] as? String {
                    self.sessionID = sessionID
                } else {
                    print("Could not find \(JSONResponseKeys.SessionID) in \(sessionDictionary)")
                     completionHandler(success: true,  errorString: nil)
                }
            } else {
                print("Could not find \(JSONResponseKeys.Session) in \(JSONResult)")
                completionHandler(success: false, errorString: "Session Not Found")
            }
            
        }
    }
    
    
    func authenticateStudentWithUdacity(username: String, password: String, completionHandler: (success: Bool, errorString: String?) -> Void) {
        
        self.getSessionID(username, password: password) { (success, errorString) in
            guard (errorString == nil) else {
                print(errorString)
                completionHandler(success: false, errorString: errorString)
                return
            }
            completionHandler(success: true,  errorString: nil)            
        }
    }

    func deleteStudentSessionWithUdacity(completionHandler: (success: Bool, errorString: String?) -> Void) {
        
        self.deleteSession(){ (success, errorString) in
            guard (errorString == nil) else {
                print(errorString)
                completionHandler(success: false, errorString: errorString)
                return
            }
            completionHandler(success: true,  errorString: nil)
        }
    }

}
