//
//  TaskDetailsViewController.swift
//  Simple Deadlines
//
//  Created by Edric MILARET on 17-01-12.
//  Copyright © 2017 Edric MILARET. All rights reserved.
//

import UIKit
import LibSimpleDeadlines

class TaskDetailsViewController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var counterView: CircleCounterView!
    
    var task: Task?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let t = task {
            titleTextField.text = t.title
            categoryTextField.text = t.category?.name
            datePicker.setDate(Date(timeIntervalSince1970: t.date!.timeIntervalSince1970), animated: false)
            setupCircleCounter()
        } else {
            task = TasksService.sharedInstance.getNewTask()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        guard !titleTextField.text!.isEmpty else {
            TasksService.sharedInstance.deleteTask(task: task!)
            return
        }
        
        task!.title = titleTextField.text
        task!.date = datePicker.date as NSDate
        if let catTitle = categoryTextField.text, !catTitle.isEmpty {
            let category = TasksService.sharedInstance.getCategory(name: catTitle)
            task?.category = category
        }
        TasksService.sharedInstance.save()
    }
    
    @IBAction func onDateChanged(_ sender: Any) {
        task?.date = datePicker.date as NSDate
        setupCircleCounter()
    }
    
    func setupCircleCounter() {
        let remainData = task!.getRemainingDaysAndColor()
        counterView.dayRemaining = remainData.0
        counterView.color = remainData.1
    }
}
