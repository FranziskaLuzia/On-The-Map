//
//  LoginViewController.swift
//  On The Map
//
//  Created by Franziska Kammerl on 6/9/18.
//  Copyright © 2018 Franziska Kammerl. All rights reserved.
//

import UIKit
import FacebookLogin
import FacebookCore
import FacebookShare
import MapKit

final class LoginViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signupButton: UIButton!
    
    // Facebook Login
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideKeyboardWhenTappedAround() 
        
        // FACEBOOK LOGIN
        var fbButton = LoginButton(readPermissions: [ .publicProfile ])
        fbButton.center = CGPoint(x: self.view.frame.width / 2, y: self.view.frame.width / 2 + 250)
        view.addSubview(fbButton)
        
        fbButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: fbButton, attribute: .top, relatedBy: .equal, toItem: signupButton, attribute: .bottom, multiplier: 1, constant: 16),
            NSLayoutConstraint(item: fbButton, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0)
            ])
        
        if AccessToken.current != nil {
            fbButton = LoginButton(readPermissions: [ .publicProfile, .email, .userFriends ])
        }
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        guard
            let email = emailTextField.text,
            let password = passwordTextField.text,
            !email.isEmpty,
            !password.isEmpty
        else {
            self.showGeneralError()
            return
        }
        login(email: email, password: password) { [weak self] success in
            DispatchQueue.main.async {
                if success {
                    self?.performSegue(withIdentifier: "login", sender: nil)
                } else {
                    self?.showGeneralError()
                }
            }
        }
    }
    
    func login(email: String, password: String, completionHandler: @escaping (Bool) -> Void) {
        var request = ParseData.shared.request
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"udacity\": {\"username\": \"\(email)\", \"password\": \"\(password)\"}}".data(using: .utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if let response = response as? HTTPURLResponse, response.statusCode == 403 || error != nil {
                completionHandler(false)
                return
            }
            let range = Range(5..<data!.count)
            guard
                let newData = data?.subdata(in: range),
                let dict = try! JSONSerialization.jsonObject(with: newData, options: .allowFragments) as? [String : Any]
            else {
                completionHandler(false)
                return
            }
            if
                let account = dict["account"] as? [String: Any],
                let key = account["key"] as? String
            {
                DataSource.shared.uniqueKey = key
                completionHandler(true)
            }
        }
        task.resume()
    }
    
    @IBAction func signUpButtonPressed(_ sender: Any) {
        UIApplication.shared.open(URL(string: "https://www.udacity.com/account/auth#!/signup")!, options: [ : ], completionHandler: nil)
    }
}
