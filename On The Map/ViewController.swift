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
        if self.emailText.text!.isEmpty || self.passwordText.text!.isEmpty {
           // self.displayErrorAlert(UdacityClient.Errors.EmptyEmailPass)
        } else {
         
        
        UdacityStudent.sharedInstance().authenticateStudentWithUdacity(emailText.text!, password: passwordText.text!) { (success, errorString) in
            if success {
                self.completeLogin()
            } else {
                self.displayError()
            }
        }
        }
        
    }
    
    
    @IBAction func signUpClick(sender: AnyObject) {
        UIApplication.sharedApplication().openURL(NSURL(string: UdacityStudent.Constants.SignupURL)!)
        
    }
    
    func completeLogin() {
        goToListView()
    }
   
    func displayError()
    {
        dispatch_async(dispatch_get_main_queue(), {

        let alertController: UIAlertController = UIAlertController(title: "Login Failed", message: "Unable to log in. Please check credentials or verify that you are connected to the internet", preferredStyle: .Alert)
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
}
