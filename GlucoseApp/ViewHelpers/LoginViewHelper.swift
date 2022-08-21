//
//  LoginViewHelper.swift
//  GlucoseApp
//
//  Created by Arnaldo Quintero on 9/2/22.
//

import Foundation
import SwiftUI
import GlucoseAppHelper

struct InputBlock : View {
    @Binding var username: String
    @Binding var password: String
    var body: some View {
        UserNameTextField(username: $username)
        Spacer().frame(width: nil, height: 15, alignment: .center)
        PasswordSecureField(password: $password)
        Spacer().frame(width: nil, height: 15, alignment: .center)
    }
}

struct LogoBlock : View {
    var body: some View {
        StylesConst.GlucoseAppLogo()
            .padding()
            .frame(width: 100.0, height: 100.0)
        StylesConst.GlucoseAppName()
            .padding()
            .frame(height: 30.0)
        Spacer().frame(width: nil, height: 50, alignment: .center)
    }
}

struct UserNameTextField : View {
    @Binding var username: String
    var body: some View {
        TextField("", text: $username)
            .GlucoseAppRoundInput(
                placeholder: "Usuario CareLink™",
                condition: username.isEmpty
            )
            .textContentType(.username)
    }
}

struct PasswordSecureField : View {
    @Binding var password: String
    var body: some View {
        SecureField("", text: $password)
            .GlucoseAppRoundInput(
                placeholder: "Contraseña",
                condition: password.isEmpty
            )
            .textContentType(.password)
    }
}

struct SaveButtonContent : View {
    var body: some View {
        let height: CGFloat = 50
        ZStack {
            RoundedRectangle(cornerRadius: 23)
                .fill(ColorsConst.BUTTON_LOGIN_BACKGROUND_COLOR)
                .frame(width: nil, height: height, alignment: .center)
            Text("Conectar")
                .modifier(ViewModifiers.GlucoseAppTextStyle(
                    color: ColorsConst.BUTTON_LOGIN_TEXT_COLOR,
                    height: height
                ))
        }
    }
}

struct ForgottenPasswordField : View {
    var body: some View {
        Text("¿Ha olvidado su contraseña?")
            .modifier(ViewModifiers.GlucoseAppTextStyle(
                fontSize: 16,
                fontWeight: .light,
                color: ColorsConst.TEXT_FORGOTTEN_PASSWORD_COLOR
            ))
    }
}
