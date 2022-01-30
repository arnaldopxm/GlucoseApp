//
//  ContentView.swift
//  GlucoseApp
//
//  Created by Arnaldo Quintero on 1/11/21.
//

import SwiftUI
import GlucoseAppHelper

struct LoginView: View {
    
    var client: CareLinkClient = CareLinkClient.singleton
    @StateObject var state: AppState = AppState.singleton
    
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var country: String = "es"
    
    var body: some View {
        if (state.loading) {
            LoaderView()
        } else {
            VStack {
                LogoBlock()
                InputBlock(username: $username, password: $password)
                Spacer()
                Button(action: {
                    state.setLoading(true)
                    client.loginSync(username: username, password: password) { _ in
                        state.setLoading(false)
                    }
                }) {
                    SaveButtonContent()
                }
                .padding(.vertical)
            }
            .padding()
            .background(ColorsConst.APP_BACKGROUND_COLOR)
        }
        
    }
}

struct InputBlock : View {
    @Binding var username: String
    @Binding var password: String
    var body: some View {
        UserNameTextField(username: $username)
        Spacer().frame(width: nil, height: 15, alignment: .center)
        PasswordSecureField(password: $password)
        Spacer().frame(width: nil, height: 15, alignment: .center)
        ForgottenPassword()
    }
}

struct LoaderView : View {
    var body: some View {
        VStack {
            Spacer()
            ProgressView().scaleEffect(3, anchor: .center)
            Spacer()
            StylesConst.GlucoseAppName()
        }
        .padding()
        .background(ColorsConst.APP_BACKGROUND_COLOR)
    }
}

struct LogoBlock : View {
    var body: some View {
        Spacer().frame(width: nil, height: 40, alignment: .center)
        StylesConst.GlucoseAppLogo()
        StylesConst.GlucoseAppName()
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
            Text("Iniciar sesión")
                .modifier(ViewModifiers.GlucoseAppTextStyle(
                    color: ColorsConst.BUTTON_LOGIN_TEXT_COLOR,
                    height: height
                ))
        }
    }
}

struct ForgottenPassword : View {
    var body: some View {
        Text("¿Ha olvidado su contraseña?")
            .modifier(ViewModifiers.GlucoseAppTextStyle(
                fontSize: 16,
                fontWeight: .light,
                color: ColorsConst.TEXT_FORGOTTEN_PASSWORD_COLOR
            ))
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
        LoginView()
            .preferredColorScheme(.dark)
    }
}
