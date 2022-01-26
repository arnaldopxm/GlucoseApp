//
//  GlucoseAppApp.swift
//  GlucoseApp
//
//  Created by Arnaldo Quintero on 1/11/21.
//

import SwiftUI
import BackgroundTasks
import GlucoseAppHelper

@main
struct GlucoseAppApp: App {
    private let identifier = "com.arnaldoquintero.GlucoseApp.Refresh"
    @StateObject var model = ViewModelPhone.singleton
    @StateObject var client = CareLinkClient.singleton
    @State var set: Bool = true
    @Environment(\.scenePhase) private var scenePhase
    
    init() {
        self.registerBgTask()
    }
    
    func registerBgTask() {
        BGTaskScheduler.shared.register(forTaskWithIdentifier: identifier, using: nil) { task in
            task.expirationHandler = {
                print("--TASK EXPIRED")
                task.setTaskCompleted(success: false)
            }
            self.handleAppRefresh(task: task as! BGAppRefreshTask)
        }
    }
    
    func handleAppRefresh(task: BGAppRefreshTask) {
        scheduleAppRefresh()
        findLastGlucoseTask(task: task)
        print("STATUS: Task handled")
    }
    
    func findLastGlucoseTask(task: BGAppRefreshTask) {
        Task.init() {
            do {
                print("FETCHING")
                let sg = try await client.getLastSensorGlucose()
                guard let sg = sg
                else {
                    task.setTaskCompleted(success: false)
                    return
                }

                if sg.lastSG.datetime != nil {
                    model.sg = "\(sg.lastSG.sg) \(sg.lastSGTrend.icon)"
                    model.sgTime = sg.lastSG.datetime!
                    model.send(message: ["SG": model.sg])
                    print("ASYNC BG CALL -> " + model.sg)
                } else {
//                    app is closed
                }

                task.setTaskCompleted(success: true)
            } catch {
                print ("ERROR FETCHING \(error.localizedDescription)")
                task.setTaskCompleted(success: false)
            }
        }
    }
    
    func scheduleAppRefresh() {
        let req = BGAppRefreshTaskRequest(identifier: identifier)
        req.earliestBeginDate = Date(timeIntervalSinceNow: 5*60)
        
        do {
            try BGTaskScheduler.shared.submit(req)
            print("--TASK SUBMITTED")
        } catch {
            print("--COULD NOT SCHEDULE REFRESH \(error.localizedDescription)")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            if client.isLoggedIn {
                ContentView()
            } else {
                LoginView().environmentObject(client)
            }
        }.onChange(of: scenePhase) { phase in
            if (phase == .active && set) {
                BGTaskScheduler.shared.cancelAllTaskRequests()
            }
            if (phase == .background) {
                print("STATUS: background")
                scheduleAppRefresh()
            }
        }
    }
}
