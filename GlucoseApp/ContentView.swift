//
//  ContentView.swift
//  GlucoseApp
//
//  Created by Arnaldo Quintero on 1/11/21.
//

import SwiftUI


struct ContentView: View {
    
    @State private var username: String = "1581862"
    @State private var password: String = "Candelaria"
    @State private var country: String = "es"
    
    var body: some View {
        VStack {
            UserNameTextField(username: $username)
            PasswordSecureField(password: $password)
            Button(action: {
                print("Hola")
                let client = CareLinkClient (username: username, password: password, countryCode: country)
                while client.loginCookie == nil {
                    print("not yet")
                }
                print(client.loginCookie)
            }) {
                SaveButtonContent()
            }
        }
        .padding()
        .background(/*@START_MENU_TOKEN@*//*@PLACEHOLDER=View@*/Color.gray/*@END_MENU_TOKEN@*/)
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
            .background(/*@START_MENU_TOKEN@*//*@PLACEHOLDER=View@*/Color.white/*@END_MENU_TOKEN@*/)
    }
}

struct PasswordSecureField : View {
    
    @Binding var password: String
    var body: some View {
        SecureField("Password", text: $password)
            .padding()
            .textContentType(.password)
            .background(/*@START_MENU_TOKEN@*//*@PLACEHOLDER=View@*/Color.white/*@END_MENU_TOKEN@*/)
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
