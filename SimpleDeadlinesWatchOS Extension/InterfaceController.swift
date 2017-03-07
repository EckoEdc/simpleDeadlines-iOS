//
//  InterfaceController.swift
//  SimpleDeadlinesWatchOS Extension
//
//  Created by Edric MILARET on 17-01-26.
//  Copyright © 2017 Edric MILARET. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity

class InterfaceController: WKInterfaceController, WCSessionDelegate {

    @IBOutlet var tableView: WKInterfaceTable!
    
    private var tasks: [[String: Any]] = [] {
        didSet {
            self.tableView.setNumberOfRows(self.tasks.count, withRowType: "taskRow")
            
            for i in 0 ..< self.tasks.count {
                if let row = self.tableView.rowController(at: i) as? TaskRow {
                    row.titleLabel.setText(self.tasks[i]["title"] as? String)
                    let color = NSKeyedUnarchiver.unarchiveObject(with: self.tasks[i]["color"] as! Data) as! UIColor
                    row.rowGroup.setBackgroundColor(color)
                }
            }
        }
    }
    
    var category: [String] = ["All"]
    var currentCategory: String = "All" {
        didSet {
            self.setTitle(currentCategory)
        }
    }
    
    var session: WCSession? {
        didSet {
            if let session = session {
                session.delegate = self
                session.activate()
            }
        }
    }
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
    }
    
    override func willActivate() {
        super.willActivate()
        if WCSession.isSupported() {
            
            if let session = session, session.activationState == .activated {
                getData()
            } else {
                self.session = WCSession.default()
            }
        }
    }
    
    override func didDeactivate() {
        super.didDeactivate()
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if error == nil {
            getData()
        } else {
            print(error!.localizedDescription)
        }
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        if (message["Reload"] as? Bool) != nil {
            getData()
            replyHandler([:])
        }
    }
    
    func getData() {
        session?.sendMessage(["Tasks" : currentCategory, "Category" : true], replyHandler: { response in
            DispatchQueue.main.async {
                self.tasks = (response["Tasks"] as! [[String: Any]])
            }
        }, errorHandler: { (error) in
            print(error)
        })
        session?.sendMessage(["Category" : true], replyHandler: { response in
            DispatchQueue.main.async {
                self.category = ["All"] + (response["Category"] as! [String])
            }
        }, errorHandler: { (error) in
            print(error)
        })
    }
    
    override func contextForSegue(withIdentifier segueIdentifier: String, in table: WKInterfaceTable, rowIndex: Int) -> Any? {
        switch segueIdentifier {
        case "taskDetails":
            return [tasks[rowIndex], session as Any]
        default:
            return nil
        }
    }
    
    @IBAction func onCategoryTouched() {
        pushController(withName: "CategoryInterfaceController", context: self)
    }
}
