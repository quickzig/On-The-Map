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
                //self.displayError(errorString)
            }
        }
        }
        
    }
    
    
    @IBAction func signUpClick(sender: AnyObject) {
        UIApplication.sharedApplication().openURL(NSURL(string: UdacityStudent.Constants.SignupURL)!)
        
    }
    
    func completeLogin() {
    
    }
   

}
