//
//  GlucoseAppPresenter.swift
//  GlucoseApp
//
//  Created by Arnaldo Quintero on 9/2/22.
//

import Foundation
import GlucoseAppHelper

public class GlucoseAppPresenter: ObservableObject {
    
    public static let singleton = GlucoseAppPresenter()
    public var loginUseCase = LoginUseCase.singleton
    
    @Published var isLoggedIn: Bool = false
    
    func setLoggedIn(_ value: Bool) {
        DispatchQueue.main.async {
            self.isLoggedIn = value
        }
    }
    
    func checkIfCredentialsAreSaved() {
        loginUseCase.loginFromSavedCredentials(completion: setLoggedIn)
    }
}
