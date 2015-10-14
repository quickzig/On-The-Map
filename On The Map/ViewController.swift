//
//  ViewController.swift
//  On The Map
//
//  Created by Brian Quick on 9/28/15.
//  Copyright © 2015 Brian Quick. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

   
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    @IBAction func loginClick(sender: AnyObject) {
        
        guard self.emailText.text!.characters.count > 0 || self.passwordText.text!.characters.count > 0 else
        {
            displayError("Missing Login info", error: "Make sure the email and password fields are filled out.")
            return
        }
        
        guard hasConnectivity() == true else
        {
            displayError("No Internet Connection Available", error: "Please confirm you have access to the internet.")
            return
        }
        
        UdacityStudent.sharedInstance().authenticateStudentWithUdacity(emailText.text!, password: passwordText.text!) { (success, errorString) in
            if success {
                self.completeLogin()
            } else {
                self.displayError("Login Failed", error: "Unable to log into Udacity")
            }
        }
        
    }
    
    
    @IBAction func signUpClick(sender: AnyObject) {
        UIApplication.sharedApplication().openURL(NSURL(string: UdacityStudent.Constants.SignupURL)!)
        
    }
    
    func completeLogin() {
        goToListView()
    }
   
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
    
    
    
    func goToListView() {
        dispatch_async(dispatch_get_main_queue(), {
            let controller = self.storyboard!.instantiateViewControllerWithIdentifier("TabBarController")
            self.presentViewController(controller, animated: true, completion: nil)
        })
    }
    
     func hasConnectivity() -> Bool {
        let reachability: Reachability = Reachability.reachabilityForInternetConnection()
        let networkStatus: Int = reachability.currentReachabilityStatus().rawValue
        return networkStatus != 0
    }
    
  
}
