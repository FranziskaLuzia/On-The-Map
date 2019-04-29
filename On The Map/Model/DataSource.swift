//
//  DataSource.swift
//  On The Map
//
//  Created by Franziska Kammerl on 7/1/18.
//  Copyright © 2018 Franziska Kammerl. All rights reserved.
//

import UIKit
import MapKit

class DataSource: NSObject {
    private let parseAPIKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
    private let parseApplicationKey = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
    
    //MARK: Singleton Instance
    static let shared = DataSource()

    //MARK: Properties
    private let parseShared = ParseData.sharedInstance()
    var studentLocations = [StudentLocationModel]()
    
    var uniqueKey = ""
    
    //MARK: Pin Down Students Locations

    func pinDownStudentsLocations() {
        parseShared.getMultipleStudentLocations() { (studentLocationDics, error) in
            if let _ = error {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: notifications.studentLocationsPinnedDownError), object: nil)
            } else {
                    return
                }
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: notifications.studentLocationsPinnedDown), object: nil)
            }
        }
    
    func getAllLocations(_ completion: ((Bool) -> Void)?) {
        
        ParseData.shared.getMultipleStudentLocations { [weak self] (models, error) in
            if let _ = error {
                completion?(false)
                return
            }
            self?.studentLocations = models ?? []
            completion?(true)
        }
        
    }
    
    func updateLocation(lat: Double, long: Double, title: String, completion: @escaping () -> Void) {
        ParseData.shared.getParticularStudentLocation(uniqueKey: DataSource.shared.uniqueKey) { [weak self] (model, string) in
            if let model = model {
                self?.putLocation(model: model, lat: lat, long: long, title: title) {
                    completion()
                }
            } else {
                self?.postLocation(lat: lat, long: long, title: title) {
                    completion()
                }
            }
        }
    }
    
    func postLocation(lat: Double, long: Double, title: String, completionHandler: @escaping () -> Void) {
        ParseData.shared.postStudentsLocation(lat: lat, long: long) { (success, error) in
            if let _ = error {
                return
            }
            
            completionHandler()
        }
    }
    
    func putLocation(model: StudentLocationModel, lat: Double, long: Double, title: String, completionHandler: @escaping () -> Void) {

        ParseData.shared.updateStudentLocationWith(objectId: model.objectID, lat: lat, long: long) { (success, error) in
            if let _ = error {
                return
            }
            if success {
                print(lat, long)
            }
        }
    }
    
    func logout() {
        var request = URLRequest(url: URL(string: "https://www.udacity.com/api/session")!)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error…
                return
            }
            let range = Range(5..<data!.count)
            let newData = data?.subdata(in: range) /* subset response data! */
            print(String(data: newData!, encoding: .utf8)!)
        }
        task.resume()
    }
}
