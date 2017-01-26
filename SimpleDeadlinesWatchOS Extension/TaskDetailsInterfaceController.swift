//
//  TaskDetailsInterfaceController.swift
//  Simple Deadlines
//
//  Created by Edric MILARET on 17-01-26.
//  Copyright © 2017 Edric MILARET. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity

class TaskDetailsInterfaceController: WKInterfaceController {

    @IBOutlet var titleLabel: WKInterfaceLabel!
    @IBOutlet var categoryLabel: WKInterfaceLabel!
    @IBOutlet var daysLeftLabel: WKInterfaceLabel!
    
    var task: [String: Any] = [:]
    var session: WCSession? = nil
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        guard context != nil else {return}
        
        let array = context as! [Any]
        
        task = array[0] as! [String: Any]
        session = array[1] as? WCSession
        
        titleLabel.setText(task["title"] as? String)
        daysLeftLabel.setText("\(task["daysLeft"] as! String) Days left")
        categoryLabel.setText(task["category"] as? String)
    }

    override func willActivate() {
        super.willActivate()
    }

    override func didDeactivate() {
        super.didDeactivate()
    }

    @IBAction func onDoneTapped() {
        session?.sendMessage(["TaskDone" : task["id"]!], replyHandler: { response in
            self.pop()
        }, errorHandler: { (error) in
            self.pop()
            print(error)
        })
        
    }
}
