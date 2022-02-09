//
//  LoaderViewHelper.swift
//  GlucoseApp
//
//  Created by Arnaldo Quintero on 9/2/22.
//

import Foundation
import SwiftUI
import GlucoseAppHelper

struct LoaderView : View {
    var body: some View {
        VStack {
            HStack {
                Spacer()
            }
            Spacer()
            ProgressView().scaleEffect(3, anchor: .center)
            Spacer()
            StylesConst.GlucoseAppName()
        }
        .padding()
        .background(ColorsConst.APP_BACKGROUND_COLOR)
    }
}
