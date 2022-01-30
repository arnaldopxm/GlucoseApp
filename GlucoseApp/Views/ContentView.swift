//
//  ContentView.swift
//  GlucoseApp
//
//  Created by Arnaldo Quintero on 14/11/21.
//

import SwiftUI
import GlucoseAppHelper

struct ContentView: View {
    var model = ViewModelPhone.singleton;
    var client = CareLinkClient.singleton;
    @StateObject var state = AppState.singleton;
    @Environment(\.scenePhase) private var scenePhase

    func onAppear() {
        print("ContentView: appeared, first fetch")
        if (!state.firstDataLoaded) {
            findLastGlucoseTask()
            state.firstDataLoaded = true;
        }
    }

    let timer = Timer.publish(every: 5 * 60, on: .main, in: .common).autoconnect()
    
    func findLastGlucoseTask(_: Any? = nil) {
        print("ContentView: ask for glucose")
        client.findLastGlucoseTaskSync(updateHandler: model.update)
    }
    
    var body: some View {
        let titleModifier = ViewModifiers.GlucoseAppTextStyle( height: 15)
        let subtitleModifier = ViewModifiers.GlucoseAppTextStyle(fontSize: 15, color: ColorsConst.TEXT_COLOR_SECONDARY, height: 10)

        VStack {
            CircleView().environmentObject(state)
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
                        Text("Última lectura")
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
                        Text("Conectado")
                            .modifier(ViewModifiers.GlucoseAppTextStyle(color: ColorsConst.SG_OK, height: 21))
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
}

struct CircleView: View {
    @EnvironmentObject var state: AppState
    var body: some View {
        let color = state.sgColor
        ZStack {
            Circle()
                .stroke(color, lineWidth: 5)
                .frame(width: 256, height: 256, alignment: .center)
                .shadow(color: color.opacity(0.3), radius: 10)
            VStack {
                Image("dataDripIcon").frame(width: 64, height: 64, alignment: .center)
                Spacer().frame(width: nil, height: 10, alignment: .center)
                HStack() {
                    Text(state.sg)
                        .modifier(ViewModifiers.GlucoseAppTextStyle(
                            fontSize: 56,
                            fontWeight: .medium,
                            color: color,
                            height: 71
                        ))
                    state.sgTrend.stacked_icons
                    
                }
                Text("mg/dL").modifier(ViewModifiers.GlucoseAppTextStyle(
                    height: 21
                ))
            }.frame(width: 256, height: 256, alignment: .center)
            
        }.padding(.top)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        return Group {
            ContentView(state: .sample_low_notrend).preferredColorScheme(.dark)
            ContentView(state: .sample_ok_up)
            ContentView(state: .sample_high_up).preferredColorScheme(.dark)
            ContentView(state: .sample_low_down)
            ContentView(state: .sample_ok_down).preferredColorScheme(.dark)
            ContentView(state: .sample_high_down)
        }
    }
}
