//
//  TodayViewController.swift
//  Simple Deadlines Urgent Widget
//
//  Created by Edric MILARET on 17-01-24.
//  Copyright © 2017 Edric MILARET. All rights reserved.
//

import UIKit
import NotificationCenter
import LibSimpleDeadlines
import CoreData

class MiniTodayViewController: UIViewController, NCWidgetProviding, NSFetchedResultsControllerDelegate, UITableViewDataSource, UITableViewDelegate {

    // MARK: - Properties
    let fetchedResultController = TasksService.sharedInstance.getFetchedResultsController(urgentOnly: true)
    
    // MARK: Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchedResultController.delegate = self
        do {
            try fetchedResultController.performFetch()
        } catch {
            //TODO
            print("ERROR")
        }
        self.extensionContext?.widgetLargestAvailableDisplayMode = .expanded
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { context in
            self.tableView.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        }, completion: nil)
    }
    
    // MARK: - Widget func
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        do {
            try fetchedResultController.performFetch()
        } catch {
            //TODO
            print("ERROR")
        }
        completionHandler(NCUpdateResult.newData)
    }
    
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        if activeDisplayMode == .compact {
            preferredContentSize = maxSize
        } else {
            let preferredSize = CGSize(width: CGFloat(0), height: CGFloat(tableView(tableView, numberOfRowsInSection: 0)) * CGFloat(tableView.rowHeight) + tableView.sectionFooterHeight)
            preferredContentSize = preferredSize
        }
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
                let cell = tableView.cellForRow(at: indexPath) as! MiniTaskTableViewCell
                let task = fetchedResultController.object(at: newIndexPath) as Task
                cell.configureCell(task: task)
                tableView.moveRow(at: indexPath, to: newIndexPath)
            }
            break;
        }
    }
    
    // MARK: UITableView
    
    @available(iOSApplicationExtension 2.0, *)
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = fetchedResultController.sections {
            let sectionInfo = sections[section]
            return sectionInfo.numberOfObjects
        }
        return 0
    }
    
    @available(iOSApplicationExtension 2.0, *)
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell") as! MiniTaskTableViewCell
        let task = fetchedResultController.object(at: indexPath) as Task
        cell.configureCell(task: task)
        return cell
    }
}
