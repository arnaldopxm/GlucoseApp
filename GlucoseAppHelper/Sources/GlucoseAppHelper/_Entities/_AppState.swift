//
//  File.swift
//  
//
//  Created by Arnaldo Quintero on 9/2/22.
//

import Foundation

public class _AppState: _WatchState {
    
    public init(gs: GlucoseModel, gsTrend: GlucoseTrendModel, gsTime: GlucoseTimeModel, credentials: CredentialsState) {
        self.credentials = credentials
        super.init(gs: gs, gsTrend: gsTrend, gsTime: gsTime)
    }
    
    public var credentials: CredentialsState
}

