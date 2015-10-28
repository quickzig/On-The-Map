//
//  MapViewController.swift
//  On The Map
//
//  Created by Brian Quick on 9/28/15.
//  Copyright © 2015 Brian Quick. All rights reserved.
//

import UIKit
import MapKit

class MapViewController:  UIViewController, MKMapViewDelegate {
   
    var studentLocations = [ParseStudentLocation]()
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showActivityIndicator(true)
        mapView.delegate = self
    
        // Do any additional setup after loading the view, typically from a nib.
        ParseUser.sharedInstance().getStudentLocations { studentLocations, error in
            if let studentLocations = studentLocations {
                self.studentLocations = studentLocations
                
                var annotations = [MKPointAnnotation]()
                
                for dictionary in studentLocations {
                    
                    // Notice that the float values are being used to create CLLocationDegree values.
                    // This is a version of the Double type.
                    
                    let lat = CLLocationDegrees(dictionary.latitude)
                    let long = CLLocationDegrees(dictionary.longitude)
                    
                    // The lat and long are used to create a CLLocationCoordinates2D instance.
                    let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                    
                    let first = dictionary.firstName
                    let last = dictionary.lastName
                    let mediaURL = dictionary.mediaURL
                    
                    // Here we create the annotation and set its coordiate, title, and subtitle properties
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = coordinate
                    annotation.title = "\(first) \(last)"
                    annotation.subtitle = mediaURL
                    
                    // Finally we place the annotation in an array of annotations.
                    annotations.append(annotation)
                }
                
                // When the array is complete, we add the annotations to the map.
                
                self.mapView.addAnnotations(annotations)
            }
        }

        
    }
    
    
    
    
    
    // Here we create a view with a "right callout accessory view". You might choose to look into other
    // decoration alternatives. Notice the similarity between this method and the cellForRowAtIndexPath
    // method in TableViewDataSource.
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinColor = .Red
            pinView!.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        self.showActivityIndicator(false)
        return pinView
        
    }
    
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.sharedApplication()
            if let toOpen = view.annotation?.subtitle! {
                app.openURL(NSURL(string: toOpen)!)
            }
        }
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


    
}