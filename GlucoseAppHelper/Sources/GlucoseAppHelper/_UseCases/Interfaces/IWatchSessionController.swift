//
//  File.swift
//  
//
//  Created by Arnaldo Quintero on 10/2/22.
//

import Foundation

public protocol IWatchSessionController {
    func send(_ message: [String: Any])
}
