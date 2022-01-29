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
    
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var country: String = "es"
    
    var body: some View {
        VStack {
            LogoBlock()
            InputBlock(username: $username, password: $password)
            Spacer()
            Button(action: {
                Task.init() {
                    do {
                        print("LoginView: calling login")
                        try await client.login(username: username, password: password)
                    } catch {
                        print("\(error)")
                    }
                    
                }
            }) {
                SaveButtonContent()
            }
            .padding(.vertical)
        }
        .padding()
        .background(Color("backgroundColor"))
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

struct LogoBlock : View {
    var body: some View {
        Spacer().frame(width: nil, height: 50, alignment: .center)
        Image("loginScreenLogo").padding().frame(width: 121, height: 121, alignment: .center)
        Text("glucosapp")
            .font(.custom("Outfit", size: 24, relativeTo: .body).weight(.medium))
            .padding(.bottom)
            .frame(height: 30.0)
            .foregroundColor(Color("inputTextColor"))
        Spacer().frame(width: nil, height: 50, alignment: .center)
    }
}

struct UserNameTextField : View {
    @Binding var username: String
    var body: some View {
        TextField(
            ""
            , text: $username
            
        )

            .placeholder("Usuario CareLink™", when: username.isEmpty)
            .padding()
            .frame(width: nil, height: 45, alignment: .center)
            .overlay(
                RoundedRectangle(cornerRadius: 23)
                    .stroke(Color("inputBorderColor"), lineWidth: 1)
            )
            .font(.custom("Outfit", size: 17, relativeTo: .body).weight(.regular))
            .textInputAutocapitalization(.never)
            .disableAutocorrection(true)
            .textContentType(.username)
            .foregroundColor(Color("inputTextColor"))
        
    }
}

struct PasswordSecureField : View {
    
    @Binding var password: String
    var body: some View {
        SecureField("", text: $password)
            .placeholder("Password", when: password.isEmpty)
            .padding()
            .textContentType(.password)
            .frame(width: nil, height: 45, alignment: .center)
            .overlay(
                RoundedRectangle(cornerRadius: 23)
                    .stroke(Color("inputBorderColor"), lineWidth: 1)
            )
            .font(.custom("Outfit", size: 17, relativeTo: .body).weight(.regular))
            .textInputAutocapitalization(.never)
            .disableAutocorrection(true)
            .textContentType(.username)
            .foregroundColor(Color("inputTextColor"))
    }
}

struct SaveButtonContent : View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 23)
                .fill(Color("loginButtonColor"))
                .frame(width: nil, height: 50, alignment: .center)
            Text("Iniciar sesión")
                .font(.custom("Outfit", size: 17, relativeTo: .body).weight(.regular))
                .foregroundColor(Color.white)
        }
    }
}

struct ForgottenPassword : View {
    var body: some View {
        Text("¿Ha olvidado su contraseña?")
            .font(.custom("Outfit", size: 16, relativeTo: .body).weight(.light))
            .foregroundColor(Color("forgottenPasswordTextColor"))
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .preferredColorScheme(.dark)
    }
}



extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {

        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}

extension View {
    func placeholder(
        _ text: String,
        when shouldShow: Bool,
        alignment: Alignment = .leading) -> some View {
            
        placeholder(when: shouldShow, alignment: alignment) { Text(text).foregroundColor(Color("inputTextColor")).font(.custom("Outfit", size: 17, relativeTo: .body).weight(.regular)) }
    }
}
