//
//  ShowLocationDataViewController.swift
//  On The Map
//
//  Created by Franziska Kammerl on 6/27/18.
//  Copyright © 2018 Franziska Kammerl. All rights reserved.
//

import UIKit

final class ShowLocationDataViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var studentTableView: UITableView!
    @IBOutlet weak var refreshButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.studentTableView.delegate = self
        self.studentTableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataSource.shared.studentLocations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "StudentCell") as? StudentCell else {
            return UITableViewCell()
        }
        
        let location = DataSource.shared.studentLocations[indexPath.row]
        
        cell.nameLabel?.text = location.student.fullName
        cell.urlLabel?.text = location.student.mediaUrl
        return cell
    }
    
    @IBAction func refreshButtonTapped(_ sender: Any ){
        DataSource.shared.getAllLocations({ (true) in
            ShowLocationDataViewController().reloadInputViews()
        })
    }
    
    @IBAction func logoutButtonTapped(_ sender: Any) {
        DataSource.shared.logout()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addLocationButtonTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "addLocation", sender: self)
    }
}

class StudentCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var urlLabel: UILabel!
  
}
