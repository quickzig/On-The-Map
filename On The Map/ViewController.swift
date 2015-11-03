//
//  ViewController.swift
//  On The Map
//
//  Created by Brian Quick on 9/28/15.
//  Copyright © 2015 Brian Quick. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITextFieldDelegate {

   
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var keyboardHidden = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailText.delegate = self
         passwordText.delegate = self
         showActivityIndicator(false)
        
    }
    
    //Check if camera button should be enabled and subscribe to keyboard notification
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
    }
    
    //Unsubscribe to keyboard notifications
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
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
                self.showActivityIndicator(true)
                self.completeLogin()
            } else {
                let animation = CABasicAnimation(keyPath: "position")
                animation.duration = 0.07
                animation.repeatCount = 4
                animation.autoreverses = true
                animation.fromValue = NSValue(CGPoint: CGPointMake(self.loginButton.center.x - 10, self.loginButton.center.y))
                animation.toValue = NSValue(CGPoint: CGPointMake(self.loginButton.center.x + 10, self.loginButton.center.y))
                self.loginButton.layer.addAnimation(animation, forKey: "position")

                
               // self.displayError("Login Failed", error: "Unable to log into Udacity")
               
            }
        }
    }
    
    
    @IBAction func signUpClick(sender: AnyObject) {
        UIApplication.sharedApplication().openURL(NSURL(string: UdacityStudent.Constants.SignupURL)!)
    }

    ///Navigate to next screen after login
    func completeLogin() {
        dispatch_async(dispatch_get_main_queue(), {
            self.showActivityIndicator(false)
            let controller = self.storyboard!.instantiateViewControllerWithIdentifier("NavigationController")
            self.presentViewController(controller, animated: true, completion: nil)
        })
    }
   
    ///Show error message
    func displayError(title: String!, error: String!)
    {
        dispatch_async(dispatch_get_main_queue(), {
        self.showActivityIndicator(false)
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
    
    func showActivityIndicator(enabled: Bool) {
        if enabled {
            UIView.animateWithDuration(1.0) {
                self.activityIndicator.alpha = 1
            }
            self.activityIndicator.startAnimating()
    
        } else {
            self.activityIndicator.alpha = 0
            self.activityIndicator.stopAnimating()
        }
    }
    
    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    
    // Determine if the keyboard will display
    //  if it's the bottem text, move display up to show the textbox.
    func keyboardWillShow(notification: NSNotification) {
        if passwordText.isFirstResponder() {
            if(keyboardHidden){
                view.frame.origin.y -= getKeyboardHeight(notification)
                keyboardHidden = false
            }
        }
    }
    
    // Determine if the keyboard will hide
    // if it's the bottem text, move display down to it's original location.
    func keyboardWillHide(notification: NSNotification) {
        if passwordText.isFirstResponder() {
            if(!keyboardHidden){
                view.frame.origin.y += getKeyboardHeight(notification)
                keyboardHidden = true
            }
        }
    }
    
    //Figure out the height of the keyboard
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true;
    }
    
    
}
