//
//  ListViewController.swift
//  On The Map
//
//  Created by Brian Quick on 9/28/15.
//  Copyright © 2015 Brian Quick. All rights reserved.
//

import UIKit

class ListViewController:  StudentLocationViewController, UITableViewDelegate, UITableViewDataSource {
  
    
    @IBOutlet weak var studentsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        studentsTableView.separatorColor = UIColor.grayColor()
        
        //Create buttons for navigation
        setNavButtons()
        
        self.studentsTableView?.contentInset = UIEdgeInsetsMake(20.0, 0.0, 0.0, 0.0);
        self.studentsTableView.dataSource = self
        self.studentsTableView.delegate = self
        loadData()
    }

    ///Load the table data
    func loadData(){
        ParseUser.sharedInstance().getStudentLocations { studentLocations, error in
            if let studentLocations = studentLocations {
                self.studentLocations = studentLocations
                dispatch_async(dispatch_get_main_queue()) {
                    self.studentsTableView.reloadData()
                }
            }
            else {
                self.displayError("Data Load Failed", error: "Unable to load data. Please try again later")
            }
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellReuseIdentifier = "StudentLocationCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier, forIndexPath: indexPath)
        let student = self.studentLocations[indexPath.row]
        cell.textLabel!.text =  "\(student.firstName as String!) \(student.lastName as String!)"
        cell.imageView!.image = UIImage(named: "pin")
        cell.detailTextLabel!.text = student.mediaURL
        cell.detailTextLabel!.textColor = UIColor.grayColor()
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studentLocations.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let url = self.studentLocations[indexPath.row].mediaURL
        let app = UIApplication.sharedApplication()
        app.openURL(NSURL(string: url)!)
    }
    
    func goToAddStudentLocation() {
        dispatch_async(dispatch_get_main_queue(), {
            let controller = self.storyboard!.instantiateViewControllerWithIdentifier("AddStudentController")
            self.presentViewController(controller, animated: true, completion: nil)
        })
    }
}