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
    var model = ViewModelPhone.singleton
    var client = CareLinkClient.singleton
    var store = PersistStore.singleton
    @State var checkForLogin: Bool = true
    @StateObject var state = AppState.singleton
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
        client.findLastGlucoseTaskSync(updateHandler: model.update)
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
            if state.isLoggedIn {
                ContentView()
            } else {
                LoginView()
            }
        }
        .onChange(of: scenePhase) { phase in
            if (phase == .active) {
                print("AppMain: goes to foreground")
                if (checkForLogin) {
                    state.setLoading(true)
                    client.checkLoginSync() { _ in
                        state.setLoading(false)
                        checkForLogin = false
                    }
                }
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
