//
//  saveLocationViewController.swift
//  On The Map
//
//  Created by Franziska Kammerl on 6/27/18.
//  Copyright © 2018 Franziska Kammerl. All rights reserved.
//

import UIKit
import MapKit

final class SaveLocationViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var selectedPin: MKPlacemark?
    let locationManager = CLLocationManager()
    var lat: Double = 0.0
    var long: Double = 0.0
    private var locationTitle = ""

    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        dropPinZoomIn(placemark: MKPlacemark.init(coordinate: CLLocationCoordinate2D.init(latitude: lat, longitude: long)))
    }
    
    func dropPinZoomIn(placemark: MKPlacemark){
        // cache the pin
        selectedPin = placemark
        
        // clear existing pins
        mapView.removeAnnotations(mapView.annotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate.latitude = lat
        annotation.coordinate.longitude = long
        mapView.addAnnotation(annotation)
        
        let coordinates = CLLocationCoordinate2D(latitude: lat, longitude: long)
        let region = MKCoordinateRegion(center: coordinates, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        mapView.setRegion(region, animated: true)
        locationManager.stopUpdatingLocation()
        
        CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: lat, longitude: long)) { [weak self] (placemarks, error) in
            guard
                let placemark = placemarks?.first,
                let city = placemark.subAdministrativeArea,
                let country = placemark.country
            else {
                self?.showGeneralError()
                return
            }
            self?.locationTitle = city + ", " + country
        }
    }

    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if locations.first != nil {
            print("location:: (location)")
        }
    }
    
    @IBAction func finishButtonTapped(_ sender: Any) {
        DataSource.shared.updateLocation(lat: lat, long: long, title: title ?? "") { [weak self] in
            DispatchQueue.main.async {
                guard let navigationController = self?.navigationController else {
                    self?.showGeneralError()
                    return
                }
                navigationController.popToRootViewController(animated: true)
            }
        }
    }
    
    func backToHome() {
        performSegue(withIdentifier: "backHome", sender: self)
    }
    
    
}
