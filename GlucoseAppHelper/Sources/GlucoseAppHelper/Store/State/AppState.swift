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
    
    @Published public private(set) var sgTime: String = ""
    
    @Published public private(set) var sgTimeOffset: String = "Hace X min."
    
    @Published public private(set) var sgTrend: SgTrend = .NONE
    
    @Published public private(set) var sgColor: Color = ColorsConst.SG_LOW


    
    public static func getDateFormated(_ dateString: String) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        guard let date = dateFormatter.date(from: dateString) else {
            return "- - -"
        }
        dateFormatter.dateFormat = "HH:mm 'h'"
        let formatedDate = dateFormatter.string(from: date)
        
        return formatedDate
        
    }
    
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
    
    public func update(from data: DataResponse) -> Bool {
        var newSg = self.sg
        var newSgTime = self.sgTime
        var newSgTimeOffset = "Hace X min."
        var newSgTrend: SgTrend = self.sgTrend
        var newSgColor: Color = self.sgColor
        var res = false
        
        if data.lastSG.datetime != nil && lastSG?.datetime != data.lastSG.datetime {
            newSg = "\(data.lastSG.sg)"
            newSgTime = AppState.getDateFormated(data.lastSG.datetime!)
            if let timeOffset = SensorGlucose.getTimeOffsetInMinutes(from: data.lastSG.datetime!) {
                newSgTimeOffset = "Hace \(timeOffset) min."
            }
            newSgTrend = data.lastSGTrend
            newSgColor = data.lastSG.sgColor
            res = true
        }
        
        if !res, let timeOffset = SensorGlucose.getTimeOffsetInMinutes(from: data.lastSG.datetime) {
            newSgTimeOffset = "Hace \(timeOffset) min."
        }
        
        DispatchQueue.main.sync {
            self.lastDataResponse = data;
            self.sg = newSg
            self.sgTime = newSgTime
            self.sgTrend = newSgTrend
            self.sgColor = newSgColor
            self.sgTimeOffset = newSgTimeOffset
        }

        return res
        
    }
    
    public func setLogin(_ value: Bool) {
        DispatchQueue.main.sync {
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
            self.sgTimeOffset = "Hace X min."
            self.sgTime = ""
            self.sg = "---"
        }
    }
    
    public func getWatchState() -> String {
        let model = WatchStateModel(sg: self.sg, sgTime: self.lastSG?.datetime ?? "", sgTrend: self.sgTrend)
        print("model", model.sg, model.sgTime, model.sgTrend, self.sg, self.sgTrend)
        return model.getStringSerialized()
    }
}
