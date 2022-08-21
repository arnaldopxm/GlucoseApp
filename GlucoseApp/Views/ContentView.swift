//
//  ContentView.swift
//  GlucoseApp
//
//  Created by Arnaldo Quintero on 14/11/21.
//

import SwiftUI
import GlucoseAppHelper

struct ContentView: View {
    
    private let session: IiOSSessionController = iOSSessionController.singleton
    @StateObject var presenter = ContentViewPresenter.singleton
    @Environment(\.scenePhase) private var scenePhase
    
    let timer = Timer.publish(every: TimeIntervalsConst.IPHONE_SCREEN_REFRESH_TIME, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack {
            StylesConst.GlucoseShowCircle(sgColor: presenter.sgColor, sg: presenter.sgValue, sgTrend: presenter.sgTrend)
            Spacer().frame(width: nil, height: 38, alignment: .center)
            Divider().background(ColorsConst.TEXT_COLOR_SECONDARY)
            SensorInfoBlock(sgTime: $presenter.sgTime, sgTimeOffset: $presenter.sgTimeOffset)
            Divider().background(ColorsConst.TEXT_COLOR_SECONDARY)
            WatchInfoBlock(watchStatusText: $presenter.watchStatus.0, watchStatusColor: $presenter.watchStatus.1)
            Divider().background(ColorsConst.TEXT_COLOR_SECONDARY)
            Spacer()
        }
        .padding()
        .background(ColorsConst.APP_BACKGROUND_COLOR)
        .onDisappear() {
            timer.upstream.connect().cancel()
        }
        .onAppear(perform: presenter.getData)
        .onReceive(timer, perform: { _ in
            print("ContentView: ask for glucose")
            presenter.getData()
        })
        
    }
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            return Group {
                ContentView()
//                ContentView(state: .sample_ok_up).preferredColorScheme(.dark)
//                ContentView(state: .sample_high_up).preferredColorScheme(.dark)
//                ContentView(state: .sample_low_down)
//                ContentView(state: .sample_ok_down).preferredColorScheme(.dark)
//                ContentView(presenter: .sample_ok_up)
            }
        }
    }
}
