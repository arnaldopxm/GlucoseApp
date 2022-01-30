//
//  Styles.Const.swift
//  
//
//  Created by Arnaldo Quintero on 30/1/22.
//

import Foundation
import SwiftUI

public struct StylesConst {
    static func appFont(fontSize: CGFloat, fontWeight: Font.Weight) -> Font {
        return Font.custom("Outfit", size: fontSize).weight(fontWeight)
    }
    
    public struct GlucoseAppName: View {
        public init() { }

        public var body: some View {
            Text("glucosapp")
                .modifier(ViewModifiers.GlucoseAppTextStyle(
                    fontSize: 24,
                    fontWeight: .medium,
                    color: ColorsConst.APP_LOGO_COLOR,
                    height: 30)
                )
                .padding(.bottom)
        }
    }
    
    public struct GlucoseAppLogo: View {
        public init() { }

        public var body: some View {
            Image("loginScreenLogo")
                .frame(width: 121, height: 121, alignment: .center)
                .padding()
        }
    }
}
