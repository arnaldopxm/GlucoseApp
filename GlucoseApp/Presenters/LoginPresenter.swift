//
//  LoginPresenter.swift
//  GlucoseApp
//
//  Created by Arnaldo Quintero on 9/2/22.
//

import Foundation
import GlucoseAppHelper

class LoginPresenter: ObservableObject {
    
    public static let singleton = LoginPresenter()
    private let useCase = LoginUseCase.singleton
    private let mainApp = GlucoseAppPresenter.singleton
    
    @Published public var username: String = ""
    @Published public var password: String = ""
    @Published public var country: String = "es"
    @Published public var loading: Bool = false
    
    public func login() {
        setLoading(true)
        useCase.login(username: username, password: password) { isLoggedIn in
            self.setLoading(false)
            self.mainApp.setLoggedIn(isLoggedIn)
        }
    }
    
    private func setLoading(_ value: Bool) {
        DispatchQueue.main.async {
            self.loading = value
        }
    }
    
}
