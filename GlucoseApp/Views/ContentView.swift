//
//  ContentView.swift
//  GlucoseApp
//
//  Created by Arnaldo Quintero on 14/11/21.
//

import SwiftUI
import GlucoseAppHelper

struct ContentView: View {
    var model = ViewModelPhone.singleton
    var client = CareLinkClient.singleton
    @StateObject var state = AppState.singleton
    @State var watchStatus: (String, Color) = WatchStatusModel.NOT_INSTALLED
    @Environment(\.scenePhase) private var scenePhase
    
    func onAppear() {
        print("ContentView: appeared, first fetch")
        if (!state.firstDataLoaded) {
            findLastGlucoseTask()
            state.firstDataLoaded = true;
        }
    }
    
    let timer = Timer.publish(every: TimeIntervalsConst.IPHONE_SCREEN_REFRESH_TIME, on: .main, in: .common).autoconnect()
    
    func findLastGlucoseTask(_: Any? = nil) {
        print("ContentView: ask for glucose")
        DispatchQueue.main.async {
            self.watchStatus = model.getWatchStatus
        }
        client.findLastGlucoseTaskSync(updateHandler: model.update)
    }
    
    var body: some View {
        let titleModifier = ViewModifiers.GlucoseAppTextStyle( height: 15)
        let subtitleModifier = ViewModifiers.GlucoseAppTextStyle(fontSize: 15, color: ColorsConst.TEXT_COLOR_SECONDARY, height: 10)
        
        VStack {
            StylesConst.GlucoseShowCircle(sgColor: state.sgColor, sg: state.sg, sgTrend: state.sgTrend)
            Spacer().frame(width: nil, height: 38, alignment: .center)
            Divider().background(ColorsConst.TEXT_COLOR_SECONDARY)
            Group {
                HStack {
                    
                    VStack(alignment: .leading) {
                        Text("Sensor")
                            .modifier(titleModifier)
                        Text("Última lectura")
                            .modifier(subtitleModifier)
                    }
                    .frame(height: 40)
                    Spacer()
                    VStack(alignment: .trailing) {
                        Text(state.sgTime)
                            .modifier(titleModifier)
                        Text(state.sgTimeOffset)
                            .modifier(subtitleModifier)
                    }
                }
                .frame(height: 20)
                .padding()
            }
            Divider().background(ColorsConst.TEXT_COLOR_SECONDARY)
            
            Group {
                HStack {
                    
                    VStack(alignment: .leading) {
                        Text("Watch")
                            .modifier(titleModifier)
                        Text("Estado conexión")
                            .modifier(subtitleModifier)
                    }
                    .frame(height: 40)
                    Spacer()
                    VStack(alignment: .trailing) {
                        Text(watchStatus.0)
                            .modifier(ViewModifiers.GlucoseAppTextStyle(color: watchStatus.1, height: 21))
                    }
                }
                .frame(height: 20)
                .padding()
            }
            Divider().background(ColorsConst.TEXT_COLOR_SECONDARY)
            Spacer()
            Button(action: {
                print("logout")
                client.logout()
            }) {
                Text("Cerrar sesión")
                    .modifier(ViewModifiers.GlucoseAppTextStyle(
                        color: ColorsConst.TEXT_COLOR_SECONDARY
                    ))
            }
        }
        .padding()
        .background(ColorsConst.APP_BACKGROUND_COLOR)
        .onDisappear() {
            timer.upstream.connect().cancel()
        }.onAppear(perform: onAppear)
            .onReceive(timer, perform: findLastGlucoseTask)
        
    }
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            return Group {
                ContentView(state: .sample_low_notrend)
                ContentView(state: .sample_ok_up).preferredColorScheme(.dark)
                ContentView(state: .sample_high_up).preferredColorScheme(.dark)
                ContentView(state: .sample_low_down)
                ContentView(state: .sample_ok_down).preferredColorScheme(.dark)
                ContentView(state: .sample_high_down)
            }
        }
    }
}
