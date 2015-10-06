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




func getSessionID(parameters: [String : AnyObject], completionHandler: (success: Bool, sessionID: String?, errorString: String?) -> Void) {
    
  //  /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
 //   let parameters = [TMDBClient.ParameterKeys.SessionID: TMDBClient.sharedInstance().sessionID!]
 //   var mutableMethod : String = Methods
    
    
    /* 2. Make the request */
  //  taskForGETMethod(Methods.AuthenticationSessionNew, parameters: parameters) { JSONResult, error in
        
        /* 3. Send the desired value(s) to completion handler */
  //      if let error = error {
  //          print(error)
  //          completionHandler(success: false, sessionID: nil, errorString: "Login Failed (Session ID).")
  //      } else {
  //          if let sessionID = JSONResult[TMDBClient.JSONResponseKeys.SessionID] as? String {
  //              completionHandler(success: true, sessionID: sessionID, errorString: nil)
  //          } else {
   //             print("Could not find \(TMDBClient.JSONResponseKeys.SessionID) in \(JSONResult)")
  //              completionHandler(success: false, sessionID: nil, errorString: "Login Failed (Session ID).")
  //          }
  ///      }
  //  }
//}
}

func authenticateWithViewController(parameters: [String : AnyObject], hostViewController: UIViewController, completionHandler: (success: Bool, errorString: String?) -> Void) {
    

   self.getSessionID(parameters) { (success, sessionID, errorString) in
        
        if success {
            
            /* Success! We have the sessionID! */
            self.sessionID = sessionID
            
            
            } else {
            completionHandler(success: success, errorString: errorString)
            }
        }
    }
}
