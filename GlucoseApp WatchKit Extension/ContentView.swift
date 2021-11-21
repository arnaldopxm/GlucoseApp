//
//  ContentView.swift
//  GlucoseApp WatchKit Extension
//
//  Created by Arnaldo Quintero on 1/11/21.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var model = ViewModelWatch()
    var body: some View {
        Text(model.sg)
            .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
