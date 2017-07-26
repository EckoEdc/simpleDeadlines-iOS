//
//  SettingsViewController.swift
//  Simple Deadlines
//
//  Created by Edric MILARET on 17-07-25.
//  Copyright © 2017 Edric MILARET. All rights reserved.
//

import UIKit

enum SettingsLiteral: String {
    case reminderNotificationSetting
    enum reminderTimeComponents: String {
        case hour
        case minutes
    }
}

class SettingsViewController: UIViewController {

    //MARK: IBOutlets
    
    @IBOutlet weak var reminderTimePicker: UIDatePicker!
    
    //MARK: Properties
    var timeModified = false
    
    //MARK: UIViewController
    
    var reminderNotificationSetting: Dictionary<String, Any>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reminderNotificationSetting = UserDefaults.standard.dictionary(forKey: SettingsLiteral.reminderNotificationSetting.rawValue)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat =  "HH:mm"
        
        let date = dateFormatter.date(from: "\(reminderNotificationSetting[SettingsLiteral.reminderTimeComponents.hour.rawValue]!):\(reminderNotificationSetting[SettingsLiteral.reminderTimeComponents.minutes.rawValue]!)")
        
        reminderTimePicker.date = date!
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if timeModified {
            NotificationHelper.sharedInstance.resetAllNotifications()
        }
        super.viewWillDisappear(animated)
    }
    
    //MARK: - IBAction
    
    @IBAction func onDoneTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func onReminderTimeChanged(_ sender: UIDatePicker) {
        timeModified = true
        let date = sender.date
        reminderNotificationSetting[SettingsLiteral.reminderTimeComponents.hour.rawValue] = date.component(.hour)
        reminderNotificationSetting[SettingsLiteral.reminderTimeComponents.minutes.rawValue] = date.component(.minute)
        UserDefaults.standard.set(reminderNotificationSetting, forKey: SettingsLiteral.reminderNotificationSetting.rawValue)
    }
    
}
