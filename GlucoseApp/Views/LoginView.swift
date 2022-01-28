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
            UserNameTextField(username: $username)
            PasswordSecureField(password: $password)
            Button(action: {
                Task.init() {
                    try await client.login(username: username, password: password)
                }
            }) {
                SaveButtonContent()
            }
        }
        .padding()
        .background(Color.gray)
    }
}

struct UserNameTextField : View {
    @Binding var username: String
    var body: some View {
        TextField("MiniMed User name", text: $username)
            .padding()
            .textInputAutocapitalization(.never)
            .disableAutocorrection(true)
            .textContentType(.username)
            .background(Color.white)
            .foregroundColor(Color.black)
    }
}

struct PasswordSecureField : View {
    
    @Binding var password: String
    var body: some View {
        SecureField("Password", text: $password)
            .padding()
            .textContentType(.password)
            .background(Color.white)
            .foregroundColor(Color.black)
    }
}

struct SaveButtonContent : View {
    var body: some View {
        Text("Save")
            .foregroundColor(Color.white)
            .padding()
            .background(Color.blue)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
