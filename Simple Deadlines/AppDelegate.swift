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

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, WCSessionDelegate {
    
    var window: UIWindow?

    var session: WCSession? {
        didSet {
            if let session = session {
                session.delegate = self
                session.activate()
            }
        }
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    @available(iOS 9.3, *)
    public func sessionDidBecomeInactive(_ session: WCSession) {
        
    }
    
    @available(iOS 9.3, *)
    public func sessionDidDeactivate(_ session: WCSession) {
        
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        if (message["Tasks"] as? Bool) != nil {
            let tasks = TasksService.sharedInstance.getTasks(undoneOnly: true)
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
    }
    
    func sendReloadMsg() {
        session?.sendMessage(["Reload" : true], replyHandler: { (response) in
            
        }) { (error) in
            print("Error")
        }
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        if WCSession.isSupported() {
            session = WCSession.default()
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

