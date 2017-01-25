//
//  TodayViewController.swift
//  Simple Deadlines iOS Widget
//
//  Created by Edric MILARET on 17-01-24.
//  Copyright © 2017 Edric MILARET. All rights reserved.
//

import UIKit
import NotificationCenter
import LibSimpleDeadlines

class TodayViewController: UIViewController, NCWidgetProviding {
    
    @IBOutlet weak var todayCounter: CircleCounterView!
    @IBOutlet weak var urgentCounter: CircleCounterView!
    @IBOutlet weak var worrycounter: CircleCounterView!
    @IBOutlet weak var niceCounter: CircleCounterView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        
        let tasks = TasksService.sharedInstance.getTasks(undoneOnly: true)
        
        //TODO: Maybe this could be optimized ?
        
        if tasks.count == 0 {
            completionHandler(NCUpdateResult.noData)
            return
        }
        
        todayCounter.dayRemaining = tasks.filter({ (task) -> Bool in
            return task.getStatus() == .TODAY
        }).count
        
        urgentCounter.dayRemaining = tasks.filter({ (task) -> Bool in
            return task.getStatus() == .URGENT
        }).count
        
        worrycounter.dayRemaining = tasks.filter({ (task) -> Bool in
            return task.getStatus() == .WORRYING
        }).count
        
        niceCounter.dayRemaining = tasks.filter({ (task) -> Bool in
            return task.getStatus() == .NICE
        }).count
        
        completionHandler(NCUpdateResult.newData)
    }
}
