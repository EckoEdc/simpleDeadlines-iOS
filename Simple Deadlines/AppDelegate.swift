//
//  AppDelegate.swift
//  Simple Deadlines
//
//  Created by Edric MILARET on 17-01-12.
//  Copyright © 2017 Edric MILARET. All rights reserved.
//

import UIKit
import WatchConnectivity
import LibSimpleDeadlines
import UserNotifications
import CleanroomLogger

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, WCSessionDelegate, UNUserNotificationCenterDelegate {

    // MARK: - Properties
    var window: UIWindow?

    var session: WCSession? {
        didSet {
            if let session = session {
                session.delegate = self
                session.activate()
            }
        }
    }
    
    // MARK: - WCSessionDelegate
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    @available(iOS 9.3, *)
    public func sessionDidBecomeInactive(_ session: WCSession) {
        
    }
    
    @available(iOS 9.3, *)
    public func sessionDidDeactivate(_ session: WCSession) {
        
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        if let category = message["Tasks"] as? String {
            
            //Well.... Flaw-p :(
            var realCategory = ""
            switch category {
            case CategoryType.all.localizedValue:
                //Dirtier by the minutes
                realCategory = CategoryType.all.rawValue.capitalizedFirst()
            case CategoryType.archive.localizedValue:
                realCategory = CategoryType.archive.rawValue.capitalizedFirst()
            default:
                realCategory = category
            }
            let tasks = TasksService.sharedInstance.getTasks(undoneOnly: true, category: realCategory)
            var response: [[String: Any]] = []
            for task in tasks {
                response.append(task.toSimpleMessage())
            }
            replyHandler(["Tasks" : response])
        }
        if let objID = message["TaskDone"] as? String {
            DispatchQueue.main.sync {
                TasksService.sharedInstance.markAsDone(objectID: objID)
            }
            replyHandler([:])
        }
        if message["Category"] as? Bool != nil {
            if let category = TasksService.sharedInstance.getAllCategory() {
                var response: [String] = [CategoryType.all.localizedValue]
                for category in category {
                    response.append(category.name!)
                }
                response.append(CategoryType.archive.localizedValue)
                Log.debug?.message(response.joined(separator: " "))
                replyHandler(["Category": response])
            } else {
                replyHandler(["Category": []])
            }
        }
    }
    
    // MARK: - WC Message func
    
    func sendReloadMsg() {
        guard session != nil, session!.isReachable else {return}
        
        session?.sendMessage(["Reload" : true], replyHandler: { (response) in })
        { (error) in
            Log.error?.message("Failed to send reload message to Apple Watch \(error)")
        }
    }
    
    // MARK: - UNUserNotificationCenterDelegate
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound, .badge])
    }
    
    // MARK: - UIApplicationDelegate
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        Log.enable()
        
        if WCSession.isSupported() {
            session = WCSession.default()
        } else {
            Log.info?.message("WCSession unssupported")
        }
        
        if #available(iOS 10.0, *) {
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options: [.badge, .alert, .sound]) { (granted, error) in
                if !granted {
                    Log.error?.message("Notification auth not granted: \(String(describing: error))")
                }
            }
            UNUserNotificationCenter.current().delegate = self
        }

        //Setup default time for reminder notification
        if UserDefaults.standard.dictionary(forKey: SettingsLiteral.reminderNotificationSetting.rawValue) == nil {
            let reminderNotificationSetting = [SettingsLiteral.reminderTimeComponents.hour.rawValue: 8, SettingsLiteral.reminderTimeComponents.minutes.rawValue: 0]
            UserDefaults.standard.set(reminderNotificationSetting, forKey: SettingsLiteral.reminderNotificationSetting.rawValue)
        }
        
        NotificationHelper.sharedInstance.setBadgeNumber()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    }

    func applicationWillTerminate(_ application: UIApplication) {
    }
}

