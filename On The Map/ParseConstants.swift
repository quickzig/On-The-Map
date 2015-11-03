//
//  ParseConstants.swift
//  On The Map
//
//  Created by Brian Quick on 10/11/15.
//  Copyright © 2015 Brian Quick. All rights reserved.
//

import Foundation

extension ParseUser {
    
    struct Constants {
        static let ParseURL : String = "https://api.parse.com/1/classes/"
        static let ParseApplicationID: String = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let RESTAPIKey: String = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        static let Limit = 100
        static let RecentlyUpdated = "-updatedAt"
    }
    
    struct Methods {
        static let StudentLocation = "StudentLocation"
    }
    
    struct ParameterKeys {
        static let Limit = "limit"
        static let Order = "order"
    }
    
    struct JSONResponseKeys {
        static let StudentLocationObjectId = "objectId"
        static let StudentLocationFirstName = "firstName"
        static let StudentLocationLastName = "lastName"
        static let StudentLocationMediaURL = "mediaURL"
        static let StudentLocationMapString = "mapString"
        static let StudentLocationLatitude = "latitude"
        static let StudentLocationLongitude = "longitude"
        static let StudentLocationUniqueKey = "uniqueKey"
        static let Results = "results"
        static let CreatedAt = "createdAt"
        static let UpdatedAt = "updatedAt"
    }

    struct Notifications {
        static let StudentLocationsWillRefresh = "StudentLocations.WillRefresh"
        static let StudentLocationsDidRefresh = "StudentLocations.DidRefresh"
        static let StudentLocationsError = "StudentLocations.Error"
    }
}