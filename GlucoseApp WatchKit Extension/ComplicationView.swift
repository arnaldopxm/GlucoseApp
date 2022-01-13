//
//  ComplicationView.swift
//  GlucoseApp WatchKit Extension
//
//  Created by Arnaldo Quintero on 9/12/21.
//

import SwiftUI
import ClockKit

struct ComplicationView: View {
    var body: some View {
        Text("151")
    }
}

struct ComplicationView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CLKComplicationTemplateGraphicCircularView(
                ComplicationView()
            ).previewContext()
            
        }
    }
}
