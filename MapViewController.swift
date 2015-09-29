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
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
}