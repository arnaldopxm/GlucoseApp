//
//  ContentViewHelper.swift
//  GlucoseApp
//
//  Created by Arnaldo Quintero on 9/2/22.
//

import Foundation
import SwiftUI
import GlucoseAppHelper

let titleModifier = ViewModifiers.GlucoseAppTextStyle( height: 15)
let subtitleModifier = ViewModifiers.GlucoseAppTextStyle(fontSize: 15, color: ColorsConst.TEXT_COLOR_SECONDARY, height: 10)

struct SensorInfoBlock: View {
    @Binding var sgTime: String
    @Binding var sgTimeOffset: String

    var body: some View {
        Group {
            HStack {
                VStack(alignment: .leading) {
                    Text("Sensor").modifier(titleModifier)
                    Text("Última lectura").modifier(subtitleModifier)
                }
                .frame(height: 40)
                Spacer()
                VStack(alignment: .trailing) {
                    Text(sgTime).modifier(titleModifier).accessibilityIdentifier("gsTimeValue")
                    Text(sgTimeOffset).modifier(subtitleModifier).accessibilityIdentifier("gsTimeOffsetValue")
                }
            }
            .frame(height: 20)
            .padding()
        }
    
    }
}

struct WatchInfoBlock: View {
    @Binding var watchStatusText: String
    @Binding var watchStatusColor: Color

    var body: some View {
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
                    Text(watchStatusText)
                        .modifier(ViewModifiers.GlucoseAppTextStyle(color: watchStatusColor, height: 21))
                }
            }
            .frame(height: 20)
            .padding()
        }
    }
}




