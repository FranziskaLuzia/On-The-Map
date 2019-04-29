//
//  AddLocationViewController.swift
//  On The Map
//
//  Created by Franziska Kammerl on 6/27/18.
//  Copyright © 2018 Franziska Kammerl. All rights reserved.
//

import UIKit
import MapKit

final class AddLocationViewController: UIViewController, UITextFieldDelegate, MKMapViewDelegate {
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var urlTextField: UITextField!

    var location: String = ""
    var urlLink: String?
    var lat: Double = 0.0
    var long: Double = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationTextField.delegate = self
        urlTextField.delegate = self
        hideKeyboardWhenTappedAround()
    }
    
    @IBAction func findLocationTapped(_ sender: Any) {
        guard let location = locationTextField.text, let url = urlTextField.text else { return }
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(location) { (placemarks, error) in
            guard
                let placemarks = placemarks,
                let city = placemarks.first,
                let lat = city.location?.coordinate.latitude,
                let long = city.location?.coordinate.longitude
            else {
                    return
            }
            print("Lat: \(lat), Lon: \(long)")
            self.lat = lat
            self.long = long
            self.showDetailScreen()
        }
    }
    
    func showDetailScreen() {
        performSegue(withIdentifier: "saveLocation", sender: self)
    }
        
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
        {
            if let vc = segue.destination as? SaveLocationViewController {
                vc.lat = lat
                vc.long = long
            }
        }
    }

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func showGeneralError() {
        let controller = UIAlertController(title: "Sorry!", message: "Something went wrong. Please try again.", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        controller.addAction(cancelAction)
        present(controller, animated: true, completion: nil)
    }
}
