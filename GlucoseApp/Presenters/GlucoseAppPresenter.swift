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
    @Published var loading: Bool = false
    
    func setLoggedIn(_ value: Bool) {
        DispatchQueue.main.async {
            self.isLoggedIn = value
        }
    }
    
    func checkIfCredentialsAreSaved() {
//        loginUseCase.loginFromSavedCredentials() { isLoggedIn in
//            self.setLoggedIn(isLoggedIn)
//            self.setLoading(false)
//        }
    }
    
    func getData() {
        if (isLoggedIn) {
            let contentView = ContentViewPresenter.singleton
            contentView.getData()
        }
    }
    
    private func setLoading(_ value: Bool) {
        DispatchQueue.main.async {
            self.loading = value
        }
    }
}
