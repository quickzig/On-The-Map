//
//  StudentLocationViewController.swift
//  On The Map
//
//  Created by Brian Quick on 11/3/15.
//  Copyright © 2015 Brian Quick. All rights reserved.
//

import Foundation
import UIKit
import MapKit

/* Base view controller with StudentLocation data */
class StudentLocationViewController: UIViewController {

    var studentLocations = [ParseStudentLocation]()
    
    func setNavButtons(){
        
        let addStudentLocationButton = UIButton()
        addStudentLocationButton.setImage(UIImage(named: "pin"), forState: .Normal)
        addStudentLocationButton.addTarget(self, action: "goToAddStudentLocation", forControlEvents: .TouchUpInside)
        addStudentLocationButton.frame = CGRectMake(0, 0, 36, 36)
        let addStudentLocationButtonItem = UIBarButtonItem(customView: addStudentLocationButton)
        let refreshButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Refresh, target: self, action: "loadData")
        self.parentViewController!.navigationItem.rightBarButtonItems = [refreshButtonItem, addStudentLocationButtonItem]
    }
    
    ///Show error message
    func displayError(title: String!, error: String!)
    {
        dispatch_async(dispatch_get_main_queue(), {
            let alertController: UIAlertController = UIAlertController(title: title, message: error, preferredStyle: .Alert)
            let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
            }
            alertController.addAction(OKAction)
            self.presentViewController(alertController, animated: true, completion: nil)
        })
    }
    
    ///Check if there is internet connectivity
    func hasConnectivity() -> Bool {
        let reachability: Reachability = Reachability.reachabilityForInternetConnection()
        let networkStatus: Int = reachability.currentReachabilityStatus().rawValue
        return networkStatus != 0
    }

}
