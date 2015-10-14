//
//  ListViewController.swift
//  On The Map
//
//  Created by Brian Quick on 9/28/15.
//  Copyright © 2015 Brian Quick. All rights reserved.
//

import UIKit


class ListViewController:  UIViewController {

    var studentLocations: [ParseStudentLocation] = [ParseStudentLocation]()

    
    @IBOutlet weak var studentsTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let studentLocationDataSource: ParseStudentLocationDataSource? = nil
        
        self.studentsTableView!.dataSource = studentLocationDataSource
        self.studentsTableView!.delegate = self
        
        
        ParseUser.sharedInstance().getStudentLocations { studentLocations, error in
           if let studentLocations = studentLocations {
                self.studentLocations = studentLocations
            dispatch_async(dispatch_get_main_queue()) {
                self.studentsTableView.reloadData()                
            }
        }
        }
    }

}

extension ListViewController: UITableViewDelegate {
    
       

}