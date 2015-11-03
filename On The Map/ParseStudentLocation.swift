//
//  ParseStudentLocation.swift
//  On The Map
//
//  Created by Brian Quick on 10/11/15.
//  Copyright © 2015 Brian Quick. All rights reserved.
//

import Foundation

struct ParseStudentLocation {
    var objectId: String
    var uniqueKey: String
    var firstName: String
    var lastName: String
    var mapString: String
    var mediaURL: String
    var latitude: Float
    var longitude: Float
    
    init(dictionary: [String : AnyObject]) {
        objectId = dictionary[ParseUser.JSONResponseKeys.StudentLocationObjectId] as! String
        uniqueKey = dictionary[ParseUser.JSONResponseKeys.StudentLocationUniqueKey] as! String
        firstName = dictionary[ParseUser.JSONResponseKeys.StudentLocationFirstName] as! String
        lastName = dictionary[ParseUser.JSONResponseKeys.StudentLocationLastName] as! String
        mapString = dictionary[ParseUser.JSONResponseKeys.StudentLocationMapString] as! String
        mediaURL = dictionary[ParseUser.JSONResponseKeys.StudentLocationMediaURL] as! String
        latitude = dictionary[ParseUser.JSONResponseKeys.StudentLocationLatitude] as! Float
        longitude = dictionary[ParseUser.JSONResponseKeys.StudentLocationLongitude] as! Float
    }
    
    static func studentLocationsFromResults(results: [[String : AnyObject]]) -> [ParseStudentLocation] {
        var studentLocations = [ParseStudentLocation]()
        for result in results {
            studentLocations.append(ParseStudentLocation(dictionary: result))
        }
        return studentLocations
    }
}