//
//  ContentView.swift
//  GlucoseApp WatchKit Extension
//
//  Created by Arnaldo Quintero on 1/11/21.
//

import SwiftUI

struct ContentView: View {
    @StateObject var model = ViewModelWatch.singleton
    var body: some View {
        VStack {
            Text(model.sg)
                .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
        }
    }
}
