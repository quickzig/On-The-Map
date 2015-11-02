//
//  InfoPostingViewController.swift
//  On The Map
//
//  Created by Brian Quick on 9/30/15.
//  Copyright © 2015 Brian Quick. All rights reserved.
//


import UIKit
import MapKit
import CoreLocation


class InfoPostingViewController: UIViewController, UITextViewDelegate{
    
    let mediaPlaceholder = "Enter a Link to Share Here"
    let locationPlaceholder = "Enter Your Location Here"
    
    
    @IBOutlet weak var locationText: UITextView!
    @IBOutlet weak var findOnMapButton: UIButton!
    @IBOutlet weak var locationMapView: MKMapView!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var mediaText: UITextView!
    
    @IBOutlet weak var whereLabel: UILabel!
    @IBOutlet weak var studyingLabel: UILabel!
    @IBOutlet weak var todayLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
   
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var middleView: UIView!
    @IBOutlet weak var bottomView: UIView!
  
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var placemark: CLPlacemark!
    
    @IBAction func cancelButtonClick(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    @IBAction func submitButtonClick(sender: UIButton) {
        
        
        guard (mediaText.text != "") else {
            self.displayError("Link is Empty", error: "Must Enter a Link.")
            return
        }
        
        
        self.showActivityIndicator(true)
        
        var mediaLocation = mediaText.text
        
        if mediaLocation.containsString("http://") == false || mediaLocation.containsString("https://") == false {
            mediaLocation = "http://" + mediaText.text
            
        }
        
        let coords = self.placemark.location!.coordinate
        
        let jsonBody: [String:AnyObject] = [
    
            ParseUser.JSONResponseKeys.StudentLocationMapString: self.locationText.text,
            ParseUser.JSONResponseKeys.StudentLocationFirstName: UdacityStudent.sharedInstance().user.firstName!,
            ParseUser.JSONResponseKeys.StudentLocationLastName: UdacityStudent.sharedInstance().user.lastName!,
            ParseUser.JSONResponseKeys.StudentLocationMediaURL: mediaLocation,
            ParseUser.JSONResponseKeys.StudentLocationLatitude: Float(coords.latitude),
            ParseUser.JSONResponseKeys.StudentLocationLongitude: Float(coords.longitude),
            ParseUser.JSONResponseKeys.StudentLocationUniqueKey: UdacityStudent.sharedInstance().user.userKey!
        ]
        
    
            ParseUser.sharedInstance().postStudentLocation(jsonBody) { success, error in
                guard (success == true) else {
                    self.displayError("Location Not Posted", error: error?.description)
                    self.showActivityIndicator(false)
                    return
                }
                
                dispatch_async(dispatch_get_main_queue()) {
                    self.dismissViewControllerAnimated(true, completion: nil)
                }               
        }
    }
    
    @IBAction func findOnMapButtonClick(sender: UIButton) {
        showActivityIndicator(true)
        
        guard (locationText.text != "") else {
            self.displayError("Location Empty", error: "Must Enter a Location.")
            return
        }
        
        let geoCoder = CLGeocoder()
        do {
            
            geoCoder.geocodeAddressString(locationText.text, completionHandler: { (results, error) -> Void in
                
                guard (error == nil) else {
                    self.showActivityIndicator(false)
                    self.displayError("Location Not Found", error: "Could Not Geocode the String.")
                    return
                }
                guard (results!.isEmpty == false) else {
                    self.showActivityIndicator(false)
                    self.displayError("Location Not Found", error: "No Address Found.")
                    return
                }
                
                    self.placemark = results?.first
                    let coordinates:CLLocationCoordinate2D = self.placemark.location!.coordinate
                    print("Lat: " + String(coordinates.latitude))
                    print("Log: " + String(coordinates.longitude))
                
                                      
                    var annotations = [MKPointAnnotation]()
                    
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = coordinates
                    annotations.append(annotation)
                
                 self.showActivityIndicator(false)
                    self.showMap()
                    
                    self.locationMapView.addAnnotations(annotations)
                    
                    let region = MKCoordinateRegionMakeWithDistance(coordinates, 2000, 2000)
                    self.locationMapView.setRegion(region, animated: true)
                    
                
            })
            
           
        }
        
        
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        locationText.text = locationPlaceholder
        mediaText.text = mediaPlaceholder
        
        mediaText.textColor = UIColor.lightGrayColor()
        locationText.textColor = UIColor.lightGrayColor()
        
        locationText.delegate = self
        mediaText.delegate = self
        if (locationText.text == "") {
            textViewDidEndEditing(locationText)
        }
        if (mediaText.text == "") {
            textViewDidEndEditing(mediaText)
        }
        //var tapDismiss = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        //self.view.addGestureRecognizer(tapDismiss)

        
         self.showActivityIndicator(false)
        hideMap()
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
    
    func showMap() {
        self.locationMapView.hidden = false
        
        self.whereLabel.alpha = 0
        self.studyingLabel.alpha = 0
        self.todayLabel.alpha = 0
        
        self.middleView.hidden = true
        
        
        self.locationMapView.alpha = 1
        self.findOnMapButton.alpha = 0
        self.submitButton.alpha = 1
        
        
        self.bottomView.backgroundColor = UIColor.clearColor()
        self.topView.backgroundColor = UIColor(red: 0.310, green: 0.533, blue: 0.713, alpha: 1.0)
        self.cancelButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState())
        
        self.mediaText.hidden = false
        
    }
    
    func hideMap(){
        self.locationMapView.hidden = true
        
        self.whereLabel.alpha = 1
        self.studyingLabel.alpha = 1
        self.todayLabel.alpha = 1
       
        middleView.hidden = false
        //bottomView.hidden = false
        
        self.locationMapView.alpha = 0
        self.findOnMapButton.alpha = 1
        self.submitButton.alpha = 0
       
         self.bottomView.backgroundColor = UIColor(red: 239, green: 239, blue: 239, alpha: 1.0)
        self.topView.backgroundColor = UIColor(red: 239, green: 239, blue: 239, alpha: 1.0)
        self.mediaText.hidden = true
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
    
    
    
    
    func dismissKeyboard(){
        locationText.resignFirstResponder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if (textView.text == "") {
            if (textView == mediaText ){
                textView.text = mediaPlaceholder
            }
            if (textView == locationText){
                textView.text = locationPlaceholder
            }
        
            textView.textColor = UIColor.lightGrayColor()
        }
        textView.resignFirstResponder()
    }
    
    func textViewDidBeginEditing(textView: UITextView){
        if (textView.text == locationPlaceholder || textView.text == mediaPlaceholder){
            textView.text = ""
            textView.textColor = UIColor.whiteColor()
        }
        textView.becomeFirstResponder()
    }
    
}



