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
    
    @StateObject var presenter = GlucoseAppPresenter.singleton
    @Environment(\.scenePhase) private var scenePhase
    
    init() {
        self.registerBgTask()
        self.scheduleAppRefresh()
    }
    
    func registerBgTask() {
        BGTaskScheduler.shared.register(forTaskWithIdentifier: AppIdentifiers.RefreshTaskIdentifier, using: nil) { task in
            task.expirationHandler = {
                print("AppMain: task expired")
                task.setTaskCompleted(success: false)
            }
            self.handleAppRefresh(task: task as! BGAppRefreshTask)
        }
    }
    
    func handleAppRefresh(task: BGAppRefreshTask) {
        scheduleAppRefresh()
        print("AppMain: Fetch BG")
        presenter.getData()
        task.setTaskCompleted(success: true)
        print("AppMain: BG finished, Task handled")
    }
    
    func scheduleAppRefresh() {
        let req = BGAppRefreshTaskRequest(identifier: AppIdentifiers.RefreshTaskIdentifier)
        req.earliestBeginDate = Date(timeIntervalSinceNow: TimeIntervalsConst.IPHONE_BG_REFRESH_TIME)
        
        do {
            print("AppMain: schedule refresh")
            try BGTaskScheduler.shared.submit(req)
            print("AppMain: refresh scheduled")
        } catch {
            print("AppMain: ERROR - could not schedule \(error.localizedDescription)")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            if presenter.loading {
                LoaderView()
            } else {
                TabView {
                    ContentView()
                        .tabItem {
                            Image(systemName: "house")
                            Text("Home")
                        }

                    ProvidersView()
                        .tabItem {
                            Image(systemName: "gear")
                            Text("Ajustes")
                        }
                }
            }
        }
        .onChange(of: scenePhase) { phase in
            if (phase == .active) {
                print("AppMain: goes to foreground")
            }
            if (phase == .background) {
                print("AppMain: goes to background")
                scheduleAppRefresh()
            }
            if (phase == .inactive) {
                print("AppMain: goes inactive")
            }
        }
    }
}
