//
//  AppState.swift
//  GlucoseApp WatchKit Extension
//
//  Created by Arnaldo Quintero on 26/1/22.
//

import Foundation
import SwiftUI

public class AppState: ObservableObject {
    
    public static var singleton = AppState()
    
    public private(set) var lastDataResponse: DataResponse? = nil;
    
    public var lastSG: SensorGlucose? {
        return lastDataResponse?.lastSG
    }
    
    @Published public var firstDataLoaded = false;
    
    @Published public private(set) var loading = false
    
    @Published public private(set) var isLoggedIn = false
    
    @Published public private(set) var sg: String = "---"
    
    @Published public private(set) var sgTime: String = "... fetching ..."
    
    @Published public private(set) var sgTrend: SgTrend = .NONE
    
    @Published public private(set) var sgColor: Color = ColorsConst.SG_OK

    public var storeModel: StoreModel? {
        if (isLoggedIn && lastDataResponse != nil) {
            return StoreModel(data: lastDataResponse!, isLoggedIn: isLoggedIn)
        } else {
            return nil
        }
    }
    
    public func loadData(from data: StoreModel?) {
        if (data != nil) {
            setLogin(data!.isLoggedIn)
            update(from: data!.data)
        }
    }

    public func update(from data: DataResponse) {
        var newSg = "---"
        var newSgTime = "No Data"
        var newSgTrend: SgTrend = .NONE
        var newSgColor: Color = ColorsConst.SG_OK
        lastDataResponse = data;
        
        if data.lastSG.datetime != nil {
            newSg = "\(data.lastSG.sg)"
            newSgTime = data.lastSG.datetime!
            newSgTrend = data.lastSGTrend
            newSgColor = data.lastSG.sgColor
        }
        
        DispatchQueue.main.async {
            self.sg = newSg
            self.sgTime = newSgTime
            self.sgTrend = newSgTrend
            self.sgColor = newSgColor
        }
    }
    
    public func setLogin(_ value: Bool) {
        DispatchQueue.main.async {
            self.isLoggedIn = value
        }
    }
    
    public func setLoading(_ value: Bool) {
        DispatchQueue.main.async {
            self.loading = value
        }
    }
    
    public func clear() {
        DispatchQueue.main.async {
            self.lastDataResponse = nil
            self.firstDataLoaded = false
            self.isLoggedIn = false
            self.sgTime = "... fetching ..."
            self.sg = "---"
        }
        
        
    }
}
