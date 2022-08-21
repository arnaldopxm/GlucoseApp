//
//  ProvidersViewHelper.swift
//  GlucoseApp
//
//  Created by Arnaldo Quintero on 21/8/22.
//

import Foundation
import SwiftUI
import GlucoseAppHelper

struct CareLinkButtonContent : View {
    @Binding var isConnected: Bool

    var body: some View {
        let height: CGFloat = 50
        let btnText = isConnected ? "Desconectar de CareLink™" : "Conectar con CareLink™"

        ZStack {
            RoundedRectangle(cornerRadius: 23)
                .fill(ColorsConst.BUTTON_LOGIN_BACKGROUND_COLOR)
                .frame(width: nil, height: height, alignment: .center)
            Text(btnText)
                .modifier(ViewModifiers.GlucoseAppTextStyle(
                    color: ColorsConst.BUTTON_LOGIN_TEXT_COLOR,
                    height: height
                ))
        }
    }
}
