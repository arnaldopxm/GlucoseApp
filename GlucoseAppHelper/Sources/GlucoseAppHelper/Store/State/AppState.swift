//
//  AppState.swift
//  GlucoseApp WatchKit Extension
//
//  Created by Arnaldo Quintero on 26/1/22.
//

import Foundation

@available(iOS 13.0, *)
@available(watchOS 6.0, *)
public class AppState: ObservableObject {
    
    public static var singleton = AppState()
    
    public private(set) var lastDataResponse: DataResponse? = nil;
    
    public var lastSG: SensorGlucose? {
        return lastDataResponse?.lastSG
    }
    
    @Published public var firstDataLoaded = false;
    
    @Published public private(set) var isLoggedIn = false
    
    @Published public private(set) var sg: String = "SG"
    
    @Published public private(set) var sgTime: String = "... fetching ..."
    
    public var storeModel: StoreModel? {
        if (isLoggedIn && lastDataResponse != nil) {
            return StoreModel(data: lastDataResponse!, isLoggedIn: isLoggedIn)
        } else {
            return nil
        }
    }
    
    public func loadData(from data: StoreModel?) {
        if (data != nil) {
            setLogin(value: data!.isLoggedIn)
            update(from: data!.data)
        }
    }

    public func update(from data: DataResponse) {
        var newSg = "---"
        var newSgTime = "No Data"
        lastDataResponse = data;
        
        if data.lastSG.datetime != nil {
            newSg = "\(data.lastSG.sg) \(data.lastSGTrend.icon)"
            newSgTime = data.lastSG.datetime!
        }
        
        DispatchQueue.main.async {
            self.sg = newSg
            self.sgTime = newSgTime
        }
    }
    
    public func setLogin(value: Bool) {
        DispatchQueue.main.async {
            self.isLoggedIn = value
        }
    }
}
