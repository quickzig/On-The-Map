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
    
    ///Get the session ID for the user
    func getSessionID(username: String, password: String, completionHandler: (success: Bool, errorString: String?) -> Void) {
        let jsonBody : [String:AnyObject] = [
            JSONBodyKeys.UdacityCredentials: [
                JSONBodyKeys.Username : username,
                JSONBodyKeys.Password : password
            ]
        ]
    
        taskForPOSTMethod(Methods.Session, jsonBody: jsonBody) { JSONResult, error in
            
            guard (error == nil) else {
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
    
    ///Delete the user's session info
    func deleteSession(completionHandler: (success: Bool, errorString: String?) -> Void){
        taskForDeleteMethod(Methods.Session) { JSONResult, error in
            guard (error == nil) else {
                completionHandler(success: false, errorString: error!.description)
                return
            }
            //Get session Info
            if let sessionDictionary = JSONResult[JSONResponseKeys.Session] as? NSDictionary {
                if let sessionID = sessionDictionary[JSONResponseKeys.SessionID] as? String {
                    self.sessionID = sessionID
                    completionHandler(success: true,  errorString: nil)
                } else {
                     completionHandler(success: false,  errorString: nil)
                }
            } else {
                completionHandler(success: false, errorString: "Session Not Found")
            }
        }
    }
    
    ///Authenticate the user
    func authenticateStudentWithUdacity(username: String, password: String, completionHandler: (success: Bool, errorString: String?) -> Void) {
        self.getSessionID(username, password: password) { (success, errorString) in
            guard (errorString == nil) else {
                completionHandler(success: false, errorString: errorString)
                return
            }
            self.getUserData(self.user.userKey!) { (success, error) in
                if success {
                completionHandler(success: success,  errorString: nil)
                } else {
                completionHandler(success: success, errorString: error)
               }
            }
        }
    }
    
    ///Delete the user's authentication
    func deleteStudentSessionWithUdacity(completionHandler: (success: Bool, errorString: String?) -> Void) {
        
        self.deleteSession(){ (success, errorString) in
            guard (errorString == nil) else {
                completionHandler(success: false, errorString: errorString)
                return
            }
            completionHandler(success: true,  errorString: nil)
        }
    }
    
    ///Get user information from Udacity
    func getUserData(userKey: String, completionHandler: (success: Bool, errorString: String?) -> Void) {
        var mutableMethod = Methods.UsersUserKey
        mutableMethod = UdacityStudent.subtituteKey(mutableMethod, key: URLKeys.UserKey, value: self.user.userKey!)!
        
        taskForGETMethod(mutableMethod) { JSONResult, error in
            guard (error == nil) else {
                completionHandler(success: false, errorString: error!.description)
                return
            }
            
            if let userDictionary = JSONResult[JSONResponseKeys.User] as? [String:AnyObject] {
                self.user.firstName = userDictionary[JSONResponseKeys.FirstName] as? String
                self.user.lastName = userDictionary[JSONResponseKeys.LastName] as? String
                completionHandler(success: true, errorString: nil)
            } else {
                completionHandler(success: false, errorString: "User Not Found")
             }
        }
    }
}
