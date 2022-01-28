//
//  ContentView.swift
//  GlucoseApp
//
//  Created by Arnaldo Quintero on 14/11/21.
//

import SwiftUI
import GlucoseAppHelper

struct ContentView: View {
    var model = ViewModelPhone.singleton;
    var client = CareLinkClient.singleton;
    @StateObject var state = AppState.singleton;
    @Environment(\.scenePhase) private var scenePhase

    func onAppear() {
        print("ContentView: appeared, first fetch")
        if (!state.firstDataLoaded) {
            findLastGlucoseTask()
            state.firstDataLoaded = true;
        }
    }

    let timer = Timer.publish(every: 5 * 60, on: .main, in: .common).autoconnect()
    
    func findLastGlucoseTask(_: Any? = nil) {
        print("ContentView: ask for glucose")
        client.findLastGlucoseTaskSync(updateHandler: model.update)
    }
       
    var body: some View {
        VStack {
            Text(state.sg)
            Text(state.sgTime)
        }
        .onDisappear() {
            timer.upstream.connect().cancel()
        }.onAppear(perform: onAppear)
        .onReceive(timer, perform: findLastGlucoseTask)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        return ContentView()
    }
}
