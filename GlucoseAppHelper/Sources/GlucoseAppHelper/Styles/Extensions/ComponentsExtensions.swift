//
//  ComponentExtensions.swift
//  
//
//  Created by Arnaldo Quintero on 30/1/22.
//

import Foundation
import SwiftUI

extension TextField {
    public func GlucoseAppRoundInput(placeholder: String, condition: Bool, fontSize: CGFloat = 17, weight: Font.Weight = .regular) -> some View {
        self.textInputAutocapitalization(.never)
            .placeholder(placeholder, when: condition)
            .disableAutocorrection(true)
            .modifier(ViewModifiers.GlucoseAppTextStyle(fontSize: fontSize, fontWeight: weight))
            .modifier(ViewModifiers.GlucoseAppRoundedCorners())
    }
}

extension SecureField {
    public func GlucoseAppRoundInput(placeholder: String, condition: Bool, fontSize: CGFloat = 17, weight: Font.Weight = .regular) -> some View {
        self.textInputAutocapitalization(.never)
            .placeholder(placeholder, when: condition)
            .disableAutocorrection(true)
            .modifier(ViewModifiers.GlucoseAppTextStyle(fontSize: fontSize, fontWeight: weight))
            .modifier(ViewModifiers.GlucoseAppRoundedCorners())
    }
}
