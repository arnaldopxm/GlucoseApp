//
//  GlucoseAppApp.swift
//  GlucoseApp WatchKit Extension
//
//  Created by Arnaldo Quintero on 1/11/21.
//

import SwiftUI
import GlucoseAppHelper

@main
struct GlucoseAppApp: App {
    
    private let session: IWatchSessionController = WatchSessionController.singleton
    private let content = ContentViewPresenter.singleton
    @WKExtensionDelegateAdaptor(WatchDelegate.self) var delegate
    
    @SceneBuilder var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
            }
        }
    }
}
