//
//  File.swift
//  
//
//  Created by Arnaldo Quintero on 9/2/22.
//

import Foundation

public class GetiPhoneDataUseCase {
    
    public static let singleton = GetiPhoneDataUseCase()
    private let dataUseCase = GetDataUseCase.singleton
    
    public func getLatestData(completion: ((_WatchState) -> Void)? = nil) {
        dataUseCase.getLatestData(completion: completion)
    }
}
