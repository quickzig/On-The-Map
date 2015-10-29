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
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

          }

    
    
    func configureUI() {
        
        self.navigationItem.title = "On The Map"
        
        //let addStudentLocationButton = UIButton()
       // addStudentLocationButton.setImage(UIImage(named: "pin"), forState: .Normal)
       // addStudentLocationButton.addTarget(self, action: "goToAddStudentLocation", forControlEvents: .TouchUpInside)
       // addStudentLocationButton.frame = CGRectMake(0, 0, 36, 36)
       // let addStudentLocationButtonItem = UIBarButtonItem(customView: addStudentLocationButton)
        //let refreshButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Refresh, target: self, action: nil)
       // self.navigationItem.rightBarButtonItems = [refreshButtonItem, addStudentLocationButtonItem]
       
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .Plain, target: self, action: "logout")
    }
    
    func logout() {
       // FacebookClient.sharedLoginManager().logOut()
      //  UdacityClient.sharedInstance().logout { (success, error) -> Void in
      //  }
       
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    

    

}
