//
//  ViewModifiers.swift
//  
//
//  Created by Arnaldo Quintero on 30/1/22.
//

import Foundation
import SwiftUI

public struct ViewModifiers {
    
    public struct GlucoseAppTextStyle: ViewModifier {
        
        public init(fontSize: CGFloat = 17, fontWeight: Font.Weight = .regular, color: Color = ColorsConst.INPUT_TEXT_COLOR, height: CGFloat = 45) {
            self.fontSize = fontSize
            self.fontWeight = fontWeight
            self.color = color
            self.height = height
        }
        
        var fontSize: CGFloat = 17
        var fontWeight: Font.Weight = .regular
        var color: Color = ColorsConst.INPUT_TEXT_COLOR
        var height: CGFloat = 45
        
        public func body(content: Content) -> some View {
            content
                .padding()
                .frame(width: nil, height: height, alignment: .center)
                .font(StylesConst.appFont(fontSize: fontSize, fontWeight: fontWeight))
                .foregroundColor(color)
        }
    }

    public struct GlucoseAppRoundedCorners: ViewModifier {
        public init(color: Color = ColorsConst.INPUT_BORDER_COLOR) {
            self.color = color
        }
        
        var color: Color = ColorsConst.INPUT_BORDER_COLOR

        public func body(content: Content) -> some View {
            content
                .overlay(
                    RoundedRectangle(cornerRadius: 23)
                        .stroke(color, lineWidth: 1)
                )
        }
    }
}

