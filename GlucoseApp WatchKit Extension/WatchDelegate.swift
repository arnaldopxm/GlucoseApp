//
//  WatchDelegate.swift
//  GlucoseApp WatchKit Extension
//
//  Created by Arnaldo Quintero on 26/1/22.
//

import WatchKit
import ClockKit

class WatchDelegate: NSObject, WKExtensionDelegate {
    
    static public var singleton = WatchDelegate()
    
    func applicationDidFinishLaunching() {
        // Perform any final initialization of your application.
        self.reloadActiveComplications()
        scheduleNextReload()
    }
    
    func applicationDidBecomeActive() {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        self.reloadActiveComplications()
        scheduleNextReload()
    }
    
    func applicationWillResignActive() {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, etc.
    }
    
    func handle(_ backgroundTasks: Set<WKRefreshBackgroundTask>) {
        // Sent when the system needs to launch the application in the background to process tasks. Tasks arrive in a set, so loop through and process each one.
        for task in backgroundTasks {
            // Use a switch statement to check the task type
            switch task {
            case let backgroundTask as WKApplicationRefreshBackgroundTask:
                // Be sure to complete the background task once you’re done.
                scheduleNextReload()
                self.reloadActiveComplications()
                backgroundTask.setTaskCompletedWithSnapshot(true)
            case let snapshotTask as WKSnapshotRefreshBackgroundTask:
                // Snapshot tasks have a unique completion call, make sure to set your expiration date
                snapshotTask.setTaskCompleted(restoredDefaultState: true, estimatedSnapshotExpiration: Date.distantFuture, userInfo: nil)
            case let connectivityTask as WKWatchConnectivityRefreshBackgroundTask:
                // Be sure to complete the connectivity task once you’re done.
                connectivityTask.setTaskCompletedWithSnapshot(true)
            case let urlSessionTask as WKURLSessionRefreshBackgroundTask:
                // Be sure to complete the URL session task once you’re done.
                urlSessionTask.setTaskCompletedWithSnapshot(true)
            default:
                // make sure to complete unhandled task types
                task.setTaskCompletedWithSnapshot(true)
            }
        }
    }
    
    func reloadActiveComplications() {
        print("ExtensionDelegate: requesting reload of complications")
        ViewModelWatch.singleton.session.sendMessage(["REQUEST":true], replyHandler: nil, errorHandler: nil)
    }
    
    func scheduleNextReload() {
        let targetDate = Date(timeIntervalSinceNow: 5 * 60)
        print("ExtensionDelegate: scheduling next update at \(targetDate)")
        
        WKExtension.shared().scheduleBackgroundRefresh(
            withPreferredDate: targetDate,
            userInfo: nil,
            scheduledCompletion: { error in
                // contrary to what the docs say, this is called when the task is scheduled, i.e. immediately
                NSLog("ExtensionDelegate: background task %@",
                      error == nil ? "scheduled successfully" : "NOT scheduled: \(error!)")
            }
        )
    }
}
