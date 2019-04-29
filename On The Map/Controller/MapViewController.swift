//
//  MapViewController.swift
//  On The Map
//
//  Created by Franziska Kammerl on 6/25/18.
//  Copyright © 2018 Franziska Kammerl. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

final class MapViewController: UIViewController, CLLocationManagerDelegate {
    
    var currentAnnotation: MKPointAnnotation? = nil
    let annotation = MKPointAnnotation()
    var locationManager: CLLocationManager!
    let dataSource = DataSource.shared
    let studentLocation = StudentLocationModel(student: StudentModel.init(uniqueKey: "", firstName: "", lastName: "String", link: "String", mediaUrl: "String"), location: LocationModel.init(latitude: 1.12, longitude: 1.12, mapString: "String"))
    let activityView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)

    
    @IBOutlet weak var mapView: StudentLocationMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        dataSource.pinDownStudentsLocations()
        writeAnnotations()
        
        activityView.center = self.view.center
        activityView.startAnimating()
        self.view.addSubview(activityView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        studentLocationsUpdated()
    }
    
    @objc func studentLocationsUpdated() {
        DataSource.shared.getAllLocations { [weak self] success in
            if success {
                self?.mapView.removeAnnotation((self?.annotation)!)
                self?.writeAnnotations()
            } else {
                self?.showGeneralError()
            }
        }
    }
    
    private func writeAnnotations() {
        var annotations = [MKPointAnnotation]()

        for studentLocation in DataSource.shared.studentLocations {
            let annotation = MKPointAnnotation()
            annotation.coordinate = studentLocation.location.coordinate
            annotation.title = studentLocation.student.fullName
            annotation.subtitle = studentLocation.student.mediaUrl
            annotations.append(annotation)
        }
        
        DispatchQueue.main.async {
            self.mapView.removeAnnotations(self.mapView.annotations)
            self.mapView.addAnnotations(annotations)
            UIApplication.shared.endIgnoringInteractionEvents()
            self.view.alpha = 1.0
        }
    }
    
    @IBAction func logoutButtonTapped(_ sender: Any) {
        DataSource.shared.logout()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func refreshButtonPressed(_ sender: Any) {
        studentLocationsUpdated()
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "addLocation", sender: self)
    }
}


extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = IdentifierModel.dropPinReuse
        
        var dropPinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if dropPinView == nil {
            dropPinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            dropPinView!.canShowCallout = true
            dropPinView!.pinTintColor = UIColor.red
            dropPinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            dropPinView!.annotation = annotation
        }
        
        activityView.stopAnimating()
        return dropPinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            if let mediaURL = NSURL(string: ((view.annotation?.subtitle)!)!) {
                if UIApplication.shared.canOpenURL(mediaURL as URL) {
                    UIApplication.shared.open(mediaURL as URL)
                } else {
                    print(Error.self)
                }
            }
        }
    }
}
