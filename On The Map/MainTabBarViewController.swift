//
//  MainTabBarController.swift
//  On The Map
//
//  Created by Brian Quick on 10/15/15.
//  Copyright © 2015 Brian Quick. All rights reserved.
//

import Foundation
import UIKit

class MainTabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()

    }
    
    func configureUI() {
        self.navigationItem.title = "On The Map"
              self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .Plain, target: self, action: "logout")
    }
    
    func logout() {
        UdacityStudent.sharedInstance().deleteStudentSessionWithUdacity() { (success, errorString) in
            if success {
                dispatch_async(dispatch_get_main_queue(), {
                    let controller = self.storyboard!.instantiateViewControllerWithIdentifier("LoginViewController")
                    self.presentViewController(controller, animated: true, completion: nil)
                })
            } else {
                self.displayError("Logout Failed", error: "Please Try Again Later")
            }
        }
    }
    
    
    func displayError(title: String!, error: String!) {
        dispatch_async(dispatch_get_main_queue(), {
            
            let alertController: UIAlertController = UIAlertController(title: title, message: error, preferredStyle: .Alert)
            let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
            }
            alertController.addAction(OKAction)
            
            self.presentViewController(alertController, animated: true, completion: nil)
        })
    }
    
    
}
