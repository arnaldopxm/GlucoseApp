//
//  ComplicationController.swift
//  GlucoseApp WatchKit Extension
//
//  Created by Arnaldo Quintero on 1/11/21.
//

import ClockKit
import WatchConnectivity
import GlucoseAppHelper


class ComplicationController: NSObject, CLKComplicationDataSource {
    
    // MARK: - Complication Configuration
    
    func getComplicationDescriptors(handler: @escaping ([CLKComplicationDescriptor]) -> Void) {
        let descriptors = [
            CLKComplicationDescriptor(identifier: "complication", displayName: "GlucoseApp", supportedFamilies: CLKComplicationFamily.allCases)
            // Multiple complication support can be added here with more descriptors
        ]
        
        // Call the handler with the currently supported complication descriptors
        handler(descriptors)
    }
    
    func handleSharedComplicationDescriptors(_ complicationDescriptors: [CLKComplicationDescriptor]) {
        // Do any necessary work to support these newly shared complication descriptors
    }
    
    // MARK: - Timeline Configuration
    
    func getTimelineEndDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
        // Call the handler with the last entry date you can currently provide or nil if you can't support future timelines
        handler(nil)
    }
    
    func getPrivacyBehavior(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationPrivacyBehavior) -> Void) {
        // Call the handler with your desired behavior when the device is locked
        handler(.showOnLockScreen)
    }
    
    // MARK: - Timeline Population
    
    func getCurrentTimelineEntry(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimelineEntry?) -> Void) {
        // Call the handler with the current timeline
        var entry: CLKComplicationTimelineEntry? = nil
        var template: CLKComplicationTemplate? = nil
        let state = ComplicationsPresenter.singleton
        // print("ESTADO: \(state.sgTimeOffset) \(state.sgValue)")
        GetWatchDataUseCase.singleton.getLatestData()
        
        switch complication.family {
        case .circularSmall:
            // face 2
            template = CLKComplicationTemplateCircularSmallSimpleText(textProvider: CLKSimpleTextProvider(text: state.sgValue))
        case .graphicCircular:
            //face 1
            template = CLKComplicationTemplateGraphicCircularStackText(line1TextProvider: CLKSimpleTextProvider(text: state.sgValue), line2TextProvider: CLKSimpleTextProvider(text: state.sgTimeOffset))
        case .utilitarianLarge:
            template = CLKComplicationTemplateUtilitarianLargeFlat(textProvider: CLKSimpleTextProvider(text: "\(state.sgValue) - \(state.sgTimeOffset)") )
        default:
            handler(nil)
            return
        }
        entry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template!)
        handler(entry)
        
    }
    
    func getTimelineEntries(for complication: CLKComplication, after date: Date, limit: Int, withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
        // Call the handler with the timeline entries after the given date
        handler(nil)
    }
    
    // MARK: - Sample Templates
    func getLocalizableSampleTemplate(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTemplate?) -> Void) {
        // This method will be called once per supported complication, and the results will be cached
        switch complication.family {
        case .circularSmall:
            let template = CLKComplicationTemplateCircularSmallRingText(textProvider: CLKSimpleTextProvider(text: "---"), fillFraction: 0.5, ringStyle: .closed)
            handler(template)
        case .graphicCircular:
            let template = CLKComplicationTemplateGraphicCircularClosedGaugeText(gaugeProvider: CLKSimpleGaugeProvider(style: CLKGaugeProviderStyle.fill, gaugeColor: .gray, fillFraction: 1), centerTextProvider: CLKSimpleTextProvider(text: "---"))
//            CLKComplicationTemplateGraphicCircularStackText(line1TextProvider: CLKSimpleTextProvider(text: "---"), line2TextProvider: CLKSimpleTextProvider(text: ""))
            handler(template)
        case .utilitarianLarge:
            let template = CLKComplicationTemplateUtilitarianLargeFlat(textProvider: CLKSimpleTextProvider(text: "--- date-time"))
            handler(template)
        default:
            handler(nil)
        }
    }
    
    
    // MARK: - Update Scheduling
    func getNextRequestedUpdateDateWithHandler(handler: (NSDate?) -> Void) {
        // Call the handler with the date when you would next like to be given the opportunity to update your complication content
        handler(NSDate(timeIntervalSinceNow: TimeIntervalsConst.WATCH_BG_REFRESH_TIME))
    }
    
    func scheduleBackgroundRefresh(withPreferredDate preferredFireDate: Date,
                          userInfo: (NSSecureCoding & NSObjectProtocol)?,
                                   scheduledCompletion: @escaping (Error?) -> Void) {
        
    }
}
