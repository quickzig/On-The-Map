//
//  ListViewController.swift
//  On The Map
//
//  Created by Brian Quick on 9/28/15.
//  Copyright © 2015 Brian Quick. All rights reserved.
//

import UIKit


class ListViewController:  UIViewController, UITableViewDelegate, UITableViewDataSource {

    var studentLocations: [ParseStudentLocation] = [ParseStudentLocation]()

    
    @IBOutlet weak var studentsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //studentsTableView.rowHeight = 45
        studentsTableView.separatorColor = UIColor.grayColor()  
        
        let addStudentLocationButton = UIButton()
        addStudentLocationButton.setImage(UIImage(named: "pin"), forState: .Normal)
        addStudentLocationButton.addTarget(self, action: "goToAddStudentLocation", forControlEvents: .TouchUpInside)
        addStudentLocationButton.frame = CGRectMake(0, 0, 36, 36)
        let addStudentLocationButtonItem = UIBarButtonItem(customView: addStudentLocationButton)
        let refreshButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Refresh, target: self, action: "loadData")
        self.parentViewController!.navigationItem.rightBarButtonItems = [refreshButtonItem, addStudentLocationButtonItem]

        self.studentsTableView?.contentInset = UIEdgeInsetsMake(20.0, 0.0, 0.0, 0.0);
        
        studentsTableView.dataSource = self
        studentsTableView.delegate = self
        loadData()
    }

    func loadData(){
        ParseUser.sharedInstance().getStudentLocations { studentLocations, error in
            if let studentLocations = studentLocations {
                self.studentLocations = studentLocations
                dispatch_async(dispatch_get_main_queue()) {
                    self.studentsTableView.reloadData()
                }
            }
        }
    }
    
     func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        /* Get cell type */
        let cellReuseIdentifier = "StudentLocationCell"
        //let cell = tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier) as UITableViewCell!
        let cell = tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier, forIndexPath: indexPath)
        let student = self.studentLocations[indexPath.row]
        cell.textLabel!.text =  "\(student.firstName as String!) \(student.lastName as String!)"
        cell.imageView!.image = UIImage(named: "pin")
        cell.detailTextLabel!.text = student.mediaURL
        cell.detailTextLabel!.textColor = UIColor.grayColor()
        //cell.imageView!.contentMode = UIViewContentMode.ScaleAspectFill
        

        
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