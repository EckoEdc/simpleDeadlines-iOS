//
//  SettingsViewController.swift
//  Simple Deadlines
//
//  Created by Edric MILARET on 17-07-25.
//  Copyright © 2017 Edric MILARET. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    //MARK: IBOutlets
    
    @IBOutlet weak var reminderTimePicker: UIDatePicker!
    
    //MARK: UIViewController
    
    var reminderNotificationSetting: Dictionary<String, Any>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reminderNotificationSetting = UserDefaults.standard.dictionary(forKey: "reminderNotificationSetting")
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat =  "HH:mm"
        
        let date = dateFormatter.date(from: "\(reminderNotificationSetting["hour"]!):\(reminderNotificationSetting["minutes"]!)")
        
        reminderTimePicker.date = date!
    }
    
    //MARK: - IBAction
    
    @IBAction func onDoneTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func onReminderTimeChanged(_ sender: UIDatePicker) {
        let date = sender.date
        reminderNotificationSetting["hour"] = date.component(.hour)
        reminderNotificationSetting["minutes"] = date.component(.minute)
        UserDefaults.standard.set(reminderNotificationSetting, forKey: "reminderNotificationSetting")
    }
    
}
