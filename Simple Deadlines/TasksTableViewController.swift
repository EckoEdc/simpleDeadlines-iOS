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
    
    var fetchedResultsController = TasksService.sharedInstance.getFetchedResultsController()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            //TODO - Error Handling ?
            print("Fetch Error")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
        }
        done.backgroundColor = UIColor.green
        let delete = UITableViewRowAction(style: .normal, title: "Delete") { action, index in
            TasksService.sharedInstance.deleteTask(task: task)
            tableView.setEditing(false, animated: true)
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
