//
//  LoginPresenter.swift
//  GlucoseApp
//
//  Created by Arnaldo Quintero on 9/2/22.
//

import Foundation
import GlucoseAppHelper
import GlucoseApp_Core

class CareLinkLoginPresenter: ObservableObject {
    
    public static let singleton = CareLinkLoginPresenter()
    private let useCase = LoginUseCase.singleton
    private let providers = ProvidersPresenter.singleton
    
    @Published public var username: String = ""
    @Published public var password: String = ""
    @Published public var country: String = "es"
    @Published public var loading: Bool = false
    
    public func login() {
        setLoading(true)
        useCase.login(username: username, password: password, provider: .CARELINK) { logInValid in
            self.setLoading(false)
            self.providers.updateData()
        }
    }
    
    private func setLoading(_ value: Bool) {
        DispatchQueue.main.async {
            self.loading = value
        }
    }
    
}
