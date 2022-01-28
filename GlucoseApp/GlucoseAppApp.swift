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
    @State var set: Bool = true
    @StateObject var state = AppState.singleton
    @Environment(\.scenePhase) private var scenePhase
    
    init() {
        self.registerBgTask()
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
        findLastGlucoseTask(task: task)
        print("AppMain: Task handled")
    }
    
    
    func findLastGlucoseTask(task: BGAppRefreshTask) {
        print("AppMain: Fetch BG")
        client.findLastGlucoseTaskSync(updateHandler: model.update)
        task.setTaskCompleted(success: false)
        print("AppMain: BG finished")
    }
    
    func scheduleAppRefresh() {
        let req = BGAppRefreshTaskRequest(identifier: AppIdentifiers.RefreshTaskIdentifier)
        req.earliestBeginDate = Date(timeIntervalSinceNow: 5*60)
        
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
            if (phase == .active && set) {
                print("AppMain: goes to foreground")
                BGTaskScheduler.shared.cancelAllTaskRequests()
                print("AppMain: load data from store")
                PersistStore.load { result in
                    print("AppMain: data loaded", result)
                    switch result {
                    case .failure(_):
                        break
                    case .success(let data):
                        state.loadData(from: data)
                    }
                }
            }
            if (phase == .background) {
                print("AppMain: goes to background")
                scheduleAppRefresh()
            }
            if (phase == .inactive) {
                print("AppMain: goes inactive")
                PersistStore.save(glucoseData: state.storeModel) { result in
                    if case .failure(let error) = result {
                        print("AppMain: failure saving persistance data")
                        fatalError(error.localizedDescription)
                    }
                }
            }
        }
    }
}
