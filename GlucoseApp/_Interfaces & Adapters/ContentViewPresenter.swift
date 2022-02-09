//
//  ContentViewPresenter.swift
//  GlucoseApp
//
//  Created by Arnaldo Quintero on 9/2/22.
//

import Foundation
import GlucoseAppHelper

public class ContentViewPresenter: ObservableObject {
    
    public static let singleton = ContentViewPresenter()
    private let logoutUseCase = LogoutUseCase.singleton
    private let mainApp = GlucoseAppPresenter.singleton
    
    func logout() {
        logoutUseCase.logout()
        mainApp.setLoggedIn(false)
    }
}
