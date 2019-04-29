//
//  ParseStudent.swift
//  On The Map
//
//  Created by Franziska Kammerl on 6/30/18.
//  Copyright © 2018 Franziska Kammerl. All rights reserved.
//

import UIKit
import MapKit

struct LocationModel {
    let latitude: Double
    let longitude: Double
    let mapString: String
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2DMake(latitude, longitude)
    }

    
    init(latitude: Double, longitude: Double, mapString: String){
        self.latitude = latitude
        self.longitude = longitude
        self.mapString = mapString
    }
}


struct StudentModel {
    let uniqueKey: String
    let firstName: String
    let lastName: String
    var link: String
    let mediaUrl: String
    var fullName: String {
        return "\(firstName) \(lastName)"
    }
    
    init(uniqueKey: String, firstName: String, lastName: String, link: String, mediaUrl: String) {
        self.uniqueKey = uniqueKey
        self.firstName = firstName
        self.lastName = lastName
        self.link = link
        self.mediaUrl = mediaUrl
    }
}

struct IdentifierModel {
    static let loginSegue = "Login"
    static let dropPinReuse = "DropPin"
    static let studentLocationCell = "StudentLocationCell"
    static let postingSegue = "presentPostingVC"
}

struct notifications {
    static let studentLocationsPinnedDown = "Student Locations Pinned Down"
    static let studentLocationsPinnedDownError = "Student Locations Pinned Down Error"
    static let loading = "Loading"
}
