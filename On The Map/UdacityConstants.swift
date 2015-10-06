//
//  UdacityConstants.swift
//  On The Map
//
//  Created by Brian Quick on 10/4/15.
//  Copyright © 2015 Brian Quick. All rights reserved.
//

extension UdacityStudent {

    // MARK: Constants
    struct Constants {
    
        static let BaseURL : String = "https://www.udacity.com/api/"
        static let SignupURL : String = "https://www.udacity.com/account/auth#!/signin"
    }

    struct Methods {
        
        // MARK: Account
        static let Session = "session"
    }
    
    struct JSONBodyKeys {
        static let UdacityCredentials = "udacity"
        static let Username = "username"
        static let Password = "password"
        //static let FacebookMobileCredentials = "access_token"
    }
    
    struct JSONResponseKeys {
        
        // MARK: General
        static let StatusMessage = "status_message"
        static let StatusCode = "status_code"

        static let SessionID = "session_id"
      
    }

}
