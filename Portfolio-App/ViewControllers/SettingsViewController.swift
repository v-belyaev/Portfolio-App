//
//  SettingsViewController.swift
//  Portfolio-App
//
//  Created by Владимир Беляев on 13.12.2020.
//

import UIKit

class SettingsViewController: UIViewController {

    // MARK: IB Outlets
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var ageLabel: UILabel!
    @IBOutlet var mailLabel: UILabel!
    @IBOutlet var phoneLabel: UILabel!
    
    // MARK: Public Properties
    var user = UserModel(name: "", age: 0, mail: "", phone: "")
    
    // MARK: ViewController Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let defaults = UserDefaults.standard
        if let savedUser = defaults.object(forKey: "savedUser") as? Data {
            let decoder = JSONDecoder()
            if let loadedUser = try? decoder.decode(UserModel.self, from: savedUser) {
                user = loadedUser
                nameLabel.text = user.name
                ageLabel.text = String(user.age)
                mailLabel.text = user.mail
                phoneLabel.text = user.phone
            }
        }
    }
    
}
