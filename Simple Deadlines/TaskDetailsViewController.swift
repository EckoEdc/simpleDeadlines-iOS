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

    // MARK: - Outlets
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var categoryTextField: AutocompleteField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var counterView: CircleCounterView!

    // MARK: - Properties
    
    var task: Task?
    var newTask = true
    
    // MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.edgesForExtendedLayout = .all
        
        if let t = task {
            newTask = false
            titleTextField.text = t.title
            categoryTextField.text = t.category?.name
            datePicker.setDate(Date(timeIntervalSince1970: t.date!.timeIntervalSince1970), animated: false)
            setupCircleCounter()
            NotificationHelper.sharedInstance.removeNotification(for: t.title!)
        } else {
            task = TasksService.sharedInstance.getNewTask()
        }
        
        if let category = TasksService.sharedInstance.getAllCategory() {
            categoryTextField.suggestions = category.map({ (category) -> String in
                return category.name!
            })
        }
        
        titleTextField.becomeFirstResponder()
    }
    
    // MARK: - Actions
    
    @IBAction func onDateChanged(_ sender: Any) {
        task?.date = datePicker.date.dateFor(.startOfDay) as NSDate
        setupCircleCounter()
    }
    
    @IBAction func textFieldPrimaryActionTriggered(_ sender: Any) {
        view.endEditing(true)
    }
    
    @IBAction func categoryPrimaryActionTriggered(_ sender: AutocompleteField) {
        if let suggestion = sender.suggestion, !suggestion.isEmpty {
            sender.text = suggestion
        }
        view.endEditing(true)
    }
    
    @IBAction func onViewTap(_ sender: Any) {
        view.endEditing(true)
    }
    
    @IBAction func onCancelTapped(_ sender: Any) {
        if newTask {
            TasksService.sharedInstance.deleteTask(task: task!)
        }
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onDoneTapped(_ sender: Any) {
        guard !titleTextField.text!.isEmpty else {
            TasksService.sharedInstance.deleteTask(task: task!)
            return
        }
        
        task!.title = titleTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        task!.date = datePicker.date.dateFor(.startOfDay) as NSDate
        if let catTitle = categoryTextField.text, !catTitle.isEmpty {
            let category = TasksService.sharedInstance.getOrCreateCategory(name: catTitle.trimmingCharacters(in: .whitespacesAndNewlines))
            task?.category = category
        }
        (UIApplication.shared.delegate as! AppDelegate).sendReloadMsg()
        TasksService.sharedInstance.save()
        
        NotificationHelper.sharedInstance.setupNotification(for: task!)
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: Circle func
    
    func setupCircleCounter() {
        let remainData = task!.getRemainingDaysAndColor()
        counterView.dayRemaining = remainData.0
        counterView.color = remainData.1
    }
}
