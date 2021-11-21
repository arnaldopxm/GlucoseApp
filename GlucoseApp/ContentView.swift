//
//  ContentView.swift
//  GlucoseApp
//
//  Created by Arnaldo Quintero on 14/11/21.
//

import SwiftUI

struct ContentView: View {
    var model = ViewModelPhone()
    @EnvironmentObject var client: CareLinkClient;
    @State var sg = "SG"
    @State var sgTime = "Time"
    let timer = Timer.publish(every: 20, on: .main, in: .common).autoconnect()
    
    func findLastGlucoseTask(_: Any? = nil) {
        Task.init() {
            if let sg = try? await client.getLastSensorGlucose() {
                self.sg = "\(sg.lastSG.sg) \(sg.lastSGTrend.icon)"
                self.sgTime = sg.lastSG.datetime
                model.send(message: ["SG": self.sg])
            }
        }
    }
    
    var body: some View {
        VStack {
            Text(sg)
            Text(sgTime)
        }
        .onAppear(perform: {
            findLastGlucoseTask()
        })
        .onDisappear() {
            timer.upstream.connect().cancel()
        }
        .onReceive(timer, perform: findLastGlucoseTask)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let client = CareLinkClient(username:"1581862", password: "Candelaria")
        return ContentView()
            .environmentObject(client)
    }
}
