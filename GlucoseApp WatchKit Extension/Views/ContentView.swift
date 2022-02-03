//
//  ContentView.swift
//  GlucoseApp WatchKit Extension
//
//  Created by Arnaldo Quintero on 1/11/21.
//

import SwiftUI
import GlucoseAppHelper

struct ContentView: View {
    @StateObject var state = WatchState.singleton
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
            }
            StylesConst.GlucoseShowCircle(
                sgColor: state.sgColor,
                sg: state.sg,
                sgTrend: state.sgTrend
            )
                .scaleEffect(0.5)
                .frame(width: 140, height: 140, alignment: .center)
            Spacer().frame(height: 10)
            Text(AppState.getDateFormated(state.sgTime))
                .modifier(ViewModifiers.GlucoseAppTextStyle(height: 21))
            Text("Hace \(SensorGlucose.getTimeOffsetInMinutes(from: state.sgTime) ?? 0) min." )
                .modifier(ViewModifiers.GlucoseAppTextStyle(fontSize: 15, color: ColorsConst.TEXT_COLOR_SECONDARY, height: 19))
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView(state: WatchState.sample_ok_notrend)
            ContentView(state: WatchState.sample_ok_up)
        }
    }
}
