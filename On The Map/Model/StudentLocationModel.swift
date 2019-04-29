//
//  StudentLocation.swift
//  On The Map
//
//  Created by Franziska Kammerl on 7/1/18.
//  Copyright © 2018 Franziska Kammerl. All rights reserved.
//

import UIKit
import Parse

struct StudentLocationModel {
    
    //MARK: Properties
    let student: StudentModel
    let location: LocationModel
    let objectID: String
    
    init(dictionary: [String : AnyObject]) {
        objectID = dictionary[ParseData.JSONResponseKeys.objectID] as? String ?? ""
        
        // Fill StudentModel Data
        let firstName = dictionary[ParseData.JSONResponseKeys.firstName] as? String ?? ""
        let lastName = dictionary[ParseData.JSONResponseKeys.lastName] as? String ?? ""
        let uniqueKey = dictionary[ParseData.JSONResponseKeys.uniqueKey] as? String ?? ""
        let mediaURL = dictionary[ParseData.JSONResponseKeys.mediaURL] as? String ?? ""
        student = StudentModel(uniqueKey: uniqueKey, firstName: firstName, lastName: lastName, link: "mapString", mediaUrl: mediaURL)
        
        // Fill LocationModel Data
        let latitude = dictionary[ParseData.JSONResponseKeys.latitude] as? Double ?? 0.0
        let longitude = dictionary[ParseData.JSONResponseKeys.longitude] as? Double ?? 0.0
        
        
        let mapString = dictionary[ParseData.JSONResponseKeys.mapString] as? String ?? ""
        location = LocationModel(latitude: latitude, longitude: longitude, mapString: mapString)
    }
    
    init (student: StudentModel, location: LocationModel) {
        objectID = ""
        self.student = student
        self.location = location
    }
    
    init(objectID: String, student: StudentModel, location: LocationModel) {
        self.objectID = objectID
        self.student = student
        self.location = location
    }
    
    //Helper Methods
    static func locationsFromDictionaries(dictionaries: [[String:AnyObject]]) -> [StudentLocationModel] {
        var studentLocations = [StudentLocationModel]()
        for studentDictionary in dictionaries {
            studentLocations.append(StudentLocationModel(dictionary: studentDictionary))
        }
        return studentLocations
    }
}
