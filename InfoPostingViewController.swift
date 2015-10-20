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


class InfoPostingViewController: UIViewController {
    
    @IBOutlet weak var locationText: UITextView!
    @IBOutlet weak var findOnMapButton: UIButton!
    @IBOutlet weak var locationMapView: MKMapView!
   
    @IBAction func cancelButtonClick(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func findOnMapButtonClick(sender: UIButton) {
        
        guard (locationText.text != "") else {
            self.displayError("Location Empty", error: "Must Enter a Location.")
            return
        }
        let geoCoder = CLGeocoder()
        do {
            
          
            
            geoCoder.geocodeAddressString(locationText.text, completionHandler: { (results, error) -> Void in
                
                guard (error == nil) else {
                    self.displayError("Location Not Found", error: "Could Not Geocode the String.")
                    return
                }
                guard (results!.isEmpty == false) else {
                    self.displayError("Location Not Found", error: "No Address Found.")
                    return
                }
                
                if let placemark = results?.first {
                    let coordinates:CLLocationCoordinate2D = placemark.location!.coordinate
                    print("Lat: " + String(coordinates.latitude))
                    print("Log: " + String(coordinates.longitude))
                    
                    var annotations = [MKPointAnnotation]()
                    
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = coordinates
                      annotations.append(annotation)
                    self.locationMapView.hidden = false

                     self.locationMapView.addAnnotations(annotations)

                }
            })
            
           
        }
        
        
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.locationMapView.hidden = true
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

    
}

