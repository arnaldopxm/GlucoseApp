//
//  GlucoseAppApp.swift
//  GlucoseApp WatchKit Extension
//
//  Created by Arnaldo Quintero on 1/11/21.
//

import SwiftUI

@main
struct GlucoseAppApp: App {
    @WKExtensionDelegateAdaptor(WatchDelegate.self) var delegate
    
    @SceneBuilder var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
            }
        }
    }
}
