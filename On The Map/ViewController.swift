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
        
        self.showActivityIndicator(true)
        UdacityStudent.sharedInstance().authenticateStudentWithUdacity(emailText.text!, password: passwordText.text!) { (success, errorString) in
            if success {
                self.completeLogin()
            } else {
                dispatch_async(dispatch_get_main_queue()) {
                    self.showActivityIndicator(false)
                    self.shakeView()
                    
                }
                
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
    
    func shakeView(){
        let shake:CABasicAnimation = CABasicAnimation(keyPath: "position")
        shake.duration = 0.1
        shake.repeatCount = 2
        shake.autoreverses = true
        
        let from_point:CGPoint = CGPointMake(self.loginButton.center.x - 5, self.loginButton.center.y)
        let from_value:NSValue = NSValue(CGPoint: from_point)
        
        let to_point:CGPoint = CGPointMake(self.loginButton.center.x + 5, self.loginButton.center.y)
        let to_value:NSValue = NSValue(CGPoint: to_point)
        
        shake.fromValue = from_value
        shake.toValue = to_value
        self.loginButton.layer.addAnimation(shake, forKey: "position")
    }
}
