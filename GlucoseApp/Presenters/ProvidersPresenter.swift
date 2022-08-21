//
//  ProvidersPresenter.swift
//  GlucoseApp
//
//  Created by Arnaldo Quintero on 21/8/22.
//

import Foundation
import GlucoseAppHelper

public class ProvidersPresenter: ObservableObject {
    
    public static let singleton = ProvidersPresenter()
    private let login = LoginUseCase.singleton
    private let logout = LogoutUseCase.singleton
    
    private var providersStatus: [ProvidersEnum: Bool] = [:]
    @Published public var anyProviderConnected: Bool = false
    @Published public var CareLinkConnected: Bool = false
    
    init() {
        self.updateData()
    }
    
    public func disconnect() {
        logout.logout(provider: .CARELINK)
        self.updateData()
    }
    
    public func updateData() {
        login.loginFromSavedCredentials(provider: .CARELINK) { isLoggedIn in
            self.setProviderStatus(.CARELINK, isLoggedIn)
        }
    }
    
    public func setProviderStatus(_ provider: ProvidersEnum, _ status: Bool) {
        DispatchQueue.main.async {
            self.providersStatus[provider] = status
            self.anyProviderConnected = self.providersStatus.values.contains(true)
            switch provider {
            case .CARELINK:
                self.CareLinkConnected = status
            }
        }
    }
}
