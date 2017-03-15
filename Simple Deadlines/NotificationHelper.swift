//
//  NotificationCenter.swift
//  Simple Deadlines
//
//  Created by Edric MILARET on 17-03-15.
//  Copyright © 2017 Edric MILARET. All rights reserved.
//

import Foundation
import UserNotifications
import LibSimpleDeadlines

// MARK: - Notifications

class NotificationHelper: TaskEventsDelegate {
    
    static var sharedInstance = NotificationHelper()
    
    private init() {
        TasksService.sharedInstance.taskEventsDelegate = self
    }
    
    func onDoneOrDelete(taskID: String) {
        removeNotification(for: taskID)
    }
    
    func removeNotification(for taskID: String) {
        
        let center = UNUserNotificationCenter.current()
        center.getPendingNotificationRequests { (notifArray) in
            if notifArray.contains(where: { (request) -> Bool in
                request.identifier == taskID
            }) {
                center.removePendingNotificationRequests(withIdentifiers: [taskID])
            } else {
                 self.setBadgeNumber()
            }
        }
    }
    
    func setupNotification(for task: Task) {
        let content = UNMutableNotificationContent()
        let number = (content.badge?.intValue ?? 0) + 1
        content.badge = NSNumber(integerLiteral: number)
        
        let triggerDate = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,.second,], from: (task.date as! Date).dateAtStartOfDay())
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
        
        let center = UNUserNotificationCenter.current()
        let request = UNNotificationRequest(identifier: task.title!,
                                            content: content, trigger: trigger)
        center.add(request, withCompletionHandler: { (error) in
            if let error = error {
                print("Error \(error)")
            }
        })
    }
    
    func setBadgeNumber() {
        UIApplication.shared.applicationIconBadgeNumber = TasksService.sharedInstance.getNumberOfExpiredTask()
    }
}

