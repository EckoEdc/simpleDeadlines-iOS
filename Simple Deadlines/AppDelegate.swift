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
class AppDelegate: UIResponder, UIApplicationDelegate, WCSessionDelegate {

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
            let tasks = TasksService.sharedInstance.getTasks(undoneOnly: true, category: category)
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
                var response: [String] = []
                for category in category {
                    response.append(category.name!)
                }
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
            center.requestAuthorization(options: [.badge]) { (granted, error) in
                if !granted {
                    Log.error?.message("Notification auth not granted: \(String(describing: error))")
                }
            }
        }
        
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

