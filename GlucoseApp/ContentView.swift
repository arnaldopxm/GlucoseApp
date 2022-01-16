//
//  ContentView.swift
//  GlucoseApp
//
//  Created by Arnaldo Quintero on 14/11/21.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var model: ViewModelPhone;
    @EnvironmentObject var client: CareLinkClient;

    let timer = Timer.publish(every: 20, on: .main, in: .common).autoconnect()
    
    func findLastGlucoseTask(_: Any? = nil) {
        client.findLastGlucoseTaskSync(updateHandler: model.update)
    }
       
    var body: some View {
        VStack {
            Text(model.sg)
            Text(model.sgTime)
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
