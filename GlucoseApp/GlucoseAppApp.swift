//
//  GlucoseAppApp.swift
//  GlucoseApp
//
//  Created by Arnaldo Quintero on 1/11/21.
//

import SwiftUI

@main
struct GlucoseAppApp: App {
    @StateObject var client = CareLinkClient() 
    var body: some Scene {
        WindowGroup {
            if client.isLoggedIn {
                ContentView()
                    .environmentObject(client)
            } else {
                LoginView()
                    .environmentObject(client)
            }
            
        }
    }
}
