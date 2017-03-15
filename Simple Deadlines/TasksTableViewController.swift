//
//  TasksTableViewController.swift
//  Simple Deadlines
//
//  Created by Edric MILARET on 17-01-12.
//  Copyright © 2017 Edric MILARET. All rights reserved.
//

import UIKit
import CoreData
import LibSimpleDeadlines

class TasksTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    // MARK: - Properties
    let fetchedResultsController = TasksService.sharedInstance.getFetchedResultsController()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchedResultsController.delegate = self
        do {
            try fetchedResultsController.performFetch()
        } catch {
            //TODO - Error Handling
            print("Fetch Error")
        }
    }

    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = fetchedResultsController.sections {
            let sectionInfo = sections[section]
            return sectionInfo.numberOfObjects
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell")! as! TaskTableViewCell
        let task = fetchedResultsController.object(at: indexPath) as Task
        cell.configureCell(task: task)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]? {
        
        let task = self.fetchedResultsController.object(at: editActionsForRowAt) as Task
        
        let done = UITableViewRowAction(style: .normal, title: "Done") { action, index in
            TasksService.sharedInstance.markAsDone(task: task)
            tableView.setEditing(false, animated: true)
            (UIApplication.shared.delegate as! AppDelegate).sendReloadMsg()
        }
        done.backgroundColor = UIColor.green
        let delete = UITableViewRowAction(style: .normal, title: "Delete") { action, index in
            TasksService.sharedInstance.deleteTask(task: task)
            tableView.setEditing(false, animated: true)
            (UIApplication.shared.delegate as! AppDelegate).sendReloadMsg()
        }
        delete.backgroundColor = UIColor.red
        return [delete, done]
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // MARK: - NSFetchedResultsControllerDelegate
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch (type) {
        case .insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            break;
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            break;
        case .update:
            if let indexPath = indexPath {
                tableView.reloadRows(at: [indexPath], with: .automatic)
            }
            break;
        case .move:
            if let indexPath = indexPath, let newIndexPath = newIndexPath {
                let cell = tableView.cellForRow(at: indexPath) as! TaskTableViewCell
                let task = fetchedResultsController.object(at: newIndexPath) as Task
                cell.configureCell(task: task)
                tableView.moveRow(at: indexPath, to: newIndexPath)
            }
            break;
        }
    }
    
    func filterByCategory(categoryName: String? = nil) {
        TasksService.sharedInstance.filterFetchedResultsByCategory(fetchedResultsController: fetchedResultsController, categoryName: categoryName)
        tableView.reloadData()
    }
    
    // MARK: - Action Sheet
    
    @IBAction func onCategoryButtonTouched(_ sender: UIButton) {
        let alertController = UIAlertController(title: nil, message: "Choose a category to display", preferredStyle: .actionSheet)
        
        let action = UIAlertAction(title: "All", style: .default, handler: { (alertAction) in
            sender.setTitle("All", for: .normal)
            self.filterByCategory()
        })
        alertController.addAction(action)
        
        if let categoryArray = TasksService.sharedInstance.getAllCategory() {
            for category in categoryArray {
                if category.tasks != nil, category.tasks!.count > 0 {
                    let action = UIAlertAction(title: category.name , style: .default, handler: { (alertAction) in
                        sender.setTitle(category.name, for: .normal)
                        self.filterByCategory(categoryName: category.name)
                    })
                    alertController.addAction(action)
                }
            }
        }
        alertController.popoverPresentationController?.sourceView = sender
        alertController.popoverPresentationController?.sourceRect = sender.bounds
        self.present(alertController, animated: true)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let id = segue.identifier {
            switch id {
            case "showTask":
                if let index = tableView.indexPathForSelectedRow {
                    let vc = segue.destination as! TaskDetailsViewController
                    vc.task = fetchedResultsController.object(at: index)
                }
                break
            default:
                break
            }
        }
    }
}
