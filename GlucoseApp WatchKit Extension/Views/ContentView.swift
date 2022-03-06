//
//  ContentView.swift
//  GlucoseApp WatchKit Extension
//
//  Created by Arnaldo Quintero on 1/11/21.
//

import SwiftUI
import GlucoseAppHelper

struct ContentView: View {

    @StateObject var presenter = ContentViewPresenter.singleton
    
    let timer = Timer.publish(every: TimeIntervalsConst.WATCH_SCREEN_REFRESH_TIME, on: .main, in: .common).autoconnect()
    
    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .center) {
                StylesConst.GlucoseShowCircle(
                    sgColor: presenter.sgColor,
                    sg: presenter.sgValue,
                    sgTrend: presenter.sgTrend
                )
                    .scaleEffect(0.4)
                    .frame(width: 120, height: 110, alignment: .center)
                Spacer()
                Text(presenter.sgTime)
                    .modifier(ViewModifiers.GlucoseAppTextStyle(height: 20))
                    .accessibilityIdentifier("gsTimeValue")
                Text(presenter.sgTimeOffset)
                    .modifier(ViewModifiers.GlucoseAppTextStyle(fontSize: 15, color: ColorsConst.TEXT_COLOR_SECONDARY, height: 20))
                    .accessibilityIdentifier("gsTimeOffsetValue")
            }
        }
        .onDisappear() {
            timer.upstream.connect().cancel()
        }
        .onAppear(perform: presenter.getData)
        .onReceive(timer, perform: { _ in
            print("ContentView Watch: ask for glucose")
            presenter.getData()
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
            ContentView()
                .previewDevice("Apple Watch Series 3 - 38mm")
//            ContentView(state: WatchState.sample_high_down)
//            ContentView(state: WatchState.sample_low_up)
        }
    }
}
