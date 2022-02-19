//
//  ContentView.swift
//  GlucoseApp
//
//  Created by Arnaldo Quintero on 1/11/21.
//

import SwiftUI
import GlucoseAppHelper

struct LoginView: View {
    
    @StateObject var presenter: LoginPresenter = LoginPresenter.singleton
    
    var body: some View {
        if (presenter.loading) {
            LoaderView()
        } else {
            VStack {
                LogoBlock()
                InputBlock(username: $presenter.username, password: $presenter.password)
                Spacer()
                Button(action: presenter.login) { SaveButtonContent() }
                .padding(.vertical)
            }
            .padding()
            .background(ColorsConst.APP_BACKGROUND_COLOR)
        }
    }
}


struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
        LoginView()
            .preferredColorScheme(.dark)
    }
}
