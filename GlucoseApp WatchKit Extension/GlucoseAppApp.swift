//
//  GlucoseAppApp.swift
//  GlucoseApp WatchKit Extension
//
//  Created by Arnaldo Quintero on 1/11/21.
//

import SwiftUI

@main
struct GlucoseAppApp: App {
    @SceneBuilder var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
            }
        }

        WKNotificationScene(controller: NotificationController.self, category: "myCategory")
    }
}
