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
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
            }
            StylesConst.GlucoseShowCircle(
                sgColor: presenter.sgColor,
                sg: presenter.sgValue,
                sgTrend: presenter.sgTrend
            )
                .scaleEffect(0.5)
                .frame(width: 140, height: 140, alignment: .center)
            Spacer().frame(height: 10)
            Text(presenter.sgTime)
                .modifier(ViewModifiers.GlucoseAppTextStyle(height: 21))
            Text(presenter.sgTimeOffset)
                .modifier(ViewModifiers.GlucoseAppTextStyle(fontSize: 15, color: ColorsConst.TEXT_COLOR_SECONDARY, height: 19))
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
//            ContentView(state: WatchState.sample_ok_notrend)
//            ContentView(state: WatchState.sample_high_down)
//            ContentView(state: WatchState.sample_low_up)
        }
    }
}
