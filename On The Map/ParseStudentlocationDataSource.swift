//
//  ParseStudentlocationDataSource.swift
//  On The Map
//
//  Created by Brian Quick on 10/14/15.
//  Copyright © 2015 Brian Quick. All rights reserved.
//

import Foundation
import UIKit

class ParseStudentLocationDataSource: NSObject {
    
    // MARK: Data
    
    var studentLocations: [ParseStudentLocation] = []
    
    // MARK: Data Notifications
    
    func sendNotificationForWillRefresh() {
        NSNotificationCenter.defaultCenter().postNotificationName(ParseUser.Notifications.StudentLocationsWillRefresh, object: nil)
    }
    
    func sendNotificationForDidRefresh() {
        NSNotificationCenter.defaultCenter().postNotificationName(ParseUser.Notifications.StudentLocationsDidRefresh, object: nil)
    }
    
    func sendNotificationForError() {
        NSNotificationCenter.defaultCenter().postNotificationName(ParseUser.Notifications.StudentLocationsError, object: nil)
    }
    
    // MARK: Refresh Data
    
    func refreshStudentLocations() {
        
        self.sendNotificationForWillRefresh()
        
        ParseUser.sharedInstance().getStudentLocations { studentLocations, error in
            if let studentLocations = studentLocations {
                self.studentLocations = studentLocations
                self.sendNotificationForDidRefresh()
            } else {
                self.sendNotificationForError()
            }
        }
    }
}

// MARK: - ParseStudentLocationDataSource: UITableViewDataSource

extension ParseStudentLocationDataSource: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.studentLocations.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let student = self.studentLocations[indexPath.row]
        
        let CellReuseIdentifier = "StandardStudentCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(CellReuseIdentifier) as UITableViewCell!
        cell.textLabel!.text =  "\(student.firstName as String!) \(student.lastName as String!)"
       // cell.imageView!.image = UIImage(named: "pin")
       // cell.imageView!.contentMode = UIViewContentMode.ScaleAspectFit
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        // Open student's URL
        let url = self.studentLocations[indexPath.row].mediaURL
        let app = UIApplication.sharedApplication()
        app.openURL(NSURL(string: url)!)
    }
}
