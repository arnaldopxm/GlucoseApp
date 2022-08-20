//
//  Styles.Const.swift
//  
//
//  Created by Arnaldo Quintero on 30/1/22.
//

import Foundation
import SwiftUI
import GlucoseApp_Core

public struct StylesConst {
    static func appFont(fontSize: CGFloat, fontWeight: Font.Weight) -> Font {
        return Font.custom("Outfit", size: fontSize).weight(fontWeight)
    }
    
    public struct GlucoseAppName: View {
        public init() { }
        
        public var body: some View {
            Text("glucoseapp")
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
    
    public struct GlucoseShowCircle: View {
        
        public init(sgColor: Color, sg: String, sgTrend: GlucoseTrendModel) {
            self.sgColor = sgColor
            self.sg = sg
            self.sgTrend = sgTrend
        }
        
        var sgColor: Color
        var sg: String
        var sgTrend: GlucoseTrendModel
        
        public var body: some View {
            ZStack {
                Circle()
                    .stroke(sgColor, lineWidth: 5)
                    .frame(width: 256, height: 256, alignment: .center)
                    .shadow(color: sgColor.opacity(0.3), radius: 10)
                VStack {
                    Image("dataDripIcon")
                        .resizable()
                        .frame(width: 64, height: 64)
                    Spacer().frame(width: nil, height: 10, alignment: .center)
                    HStack() {
                        Text(sg)
                            .modifier(ViewModifiers.GlucoseAppTextStyle(
                                fontSize: 56,
                                fontWeight: .medium,
                                color: sgColor,
                                height: 71
                            ))
                            .accessibilityIdentifier("gsValue")
                        sgTrend.getIcons
                            .accessibilityElement(children: .contain)
                            .accessibilityIdentifier("gsTrendValue")
                    }
                    Text("mg/dL").modifier(ViewModifiers.GlucoseAppTextStyle(
                        height: 21
                    ))
                }.frame(width: 256, height: 256, alignment: .center)
                
            }.padding(.top)
        }
    }
}

private extension GlucoseTrendModel {
    var getIcons: some View {
        switch _value {
        case .DOWN: return AnyView(VStack{ Image(systemName:"chevron.down") })
        case .DOWN_DOUBLE: return AnyView(VStack{
            Image(systemName:"chevron.down")
            Image(systemName:"chevron.down")
        })
        case .DOWN_TRIPLE: return AnyView(VStack{
            Image(systemName:"chevron.down")
            Image(systemName:"chevron.down")
            Image(systemName:"chevron.down")
        })
        case .UP: return AnyView(VStack{ Image(systemName:"chevron.up") })
        case .UP_DOUBLE: return AnyView(VStack{
            Image(systemName:"chevron.up")
            Image(systemName:"chevron.up")
        })
        case .UP_TRIPLE: return AnyView(VStack{
            Image(systemName:"chevron.up")
            Image(systemName:"chevron.up")
            Image(systemName:"chevron.up")
        })
        case .NONE: return AnyView(VStack{})
        }
    }
}
