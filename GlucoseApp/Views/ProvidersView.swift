//
//  ProvidersView.swift
//  GlucoseApp
//
//  Created by Arnaldo Quintero on 21/8/22.
//

import SwiftUI
import GlucoseAppHelper

struct ProvidersView: View {
    
    @StateObject var presenter: ProvidersPresenter = ProvidersPresenter.singleton

    var body: some View {
        NavigationView {
            VStack {
                LogoBlock()
                    .padding(.vertical)
                if (presenter.CareLinkConnected) {
                    Button(action: presenter.disconnect) {
                        CareLinkButtonContent(isConnected: $presenter.CareLinkConnected)
                    }
                    .padding(.vertical)
                } else {
                    NavigationLink(destination: CarelinkLoginView()) {
                        CareLinkButtonContent(isConnected: $presenter.CareLinkConnected)
                    }
                    .padding(.vertical)
                }
                Spacer()
            }
            .padding()
            .background(ColorsConst.APP_BACKGROUND_COLOR)
            .onAppear(perform: presenter.updateData)
        }
    }
}

struct ProvidersView_Previews: PreviewProvider {
    static var previews: some View {
        ProvidersView()
    }
}
