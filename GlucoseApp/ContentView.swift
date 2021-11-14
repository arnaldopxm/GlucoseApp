//
//  ContentView.swift
//  GlucoseApp
//
//  Created by Arnaldo Quintero on 14/11/21.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var client: CareLinkClient;
    @State var res = "Empty"

    var body: some View {
        VStack {
            Button(action: {
                Task.init() {
                    res = (try? await client.getData()) ?? res
                }
            }) {
                Text("Country")
                    .foregroundColor(Color.white)
                    .padding()
                    .background(Color.blue)
            }
            Text(res)
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let client = CareLinkClient(username:"1581862", password: "Candelaria")
        return ContentView()
            .environmentObject(client)
    }
}
