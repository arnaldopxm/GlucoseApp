//
//  ContentView.swift
//  GlucoseApp
//
//  Created by Arnaldo Quintero on 1/11/21.
//

import SwiftUI
import GlucoseAppHelper

struct CarelinkLoginView: View {
    
    @StateObject var presenter: CareLinkLoginPresenter = CareLinkLoginPresenter.singleton
    
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
                Spacer().frame(height: 10)
            }
            .padding()
            .background(ColorsConst.APP_BACKGROUND_COLOR)
        }
    }
}


struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        CarelinkLoginView()
        CarelinkLoginView()
            .preferredColorScheme(.dark)
    }
}
