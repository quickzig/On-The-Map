//
//  MapViewController.swift
//  On The Map
//
//  Created by Brian Quick on 9/28/15.
//  Copyright © 2015 Brian Quick. All rights reserved.
//

import UIKit
import MapKit

class MapViewController:  StudentLocationViewController, MKMapViewDelegate {
   
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Create buttons for navigation
        setNavButtons()
        
        mapView.delegate = self
        loadData()
    
    }
    ///Load the data for the map
    func loadData(){
        guard self.hasConnectivity() == true else
        {
            self.displayError("No Internet Connection Available", error: "Please confirm you have access to the internet.")
            return
        }
        
        ParseUser.sharedInstance().getStudentLocations { studentLocations, error in
            guard (error == nil) else {
                self.displayError("Error Getting Student Locations", error: error?.description)
                return
            }
            if let studentLocations = studentLocations {
                self.studentLocations = studentLocations
                var annotations = [MKPointAnnotation]()
                for dictionary in studentLocations {
                    let lat = CLLocationDegrees(dictionary.latitude)
                    let long = CLLocationDegrees(dictionary.longitude)
                    
                    let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                    let first = dictionary.firstName
                    let last = dictionary.lastName
                    let mediaURL = dictionary.mediaURL
                    
                    // Create the annotation
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = coordinate
                    annotation.title = "\(first) \(last)"
                    annotation.subtitle = mediaURL
                    annotations.append(annotation)
                }
                
                // Add the annotations to the map.
                self.mapView.addAnnotations(annotations)
            } else {
                self.displayError("Data Load Failed", error: "Unable to load data.")
            }
            
        }
    }
    

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
    
    ///Navigate to the add location screen
    func goToAddStudentLocation() {
        dispatch_async(dispatch_get_main_queue(), {
            let controller = self.storyboard!.instantiateViewControllerWithIdentifier("AddStudentController")
            self.presentViewController(controller, animated: true, completion: nil)
        })
    }
}