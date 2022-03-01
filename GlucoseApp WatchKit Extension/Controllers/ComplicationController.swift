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
            CLKComplicationDescriptor(identifier: "complication", displayName: "glucoseapp", supportedFamilies: [
                .circularSmall,
                .graphicCircular,
                .utilitarianLarge,
                .utilitarianSmall,
                .modularSmall,
                .graphicBezel,
                .graphicCorner
            ])
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
        
        let sgTextProvider = CLKSimpleTextProvider(text: state.sgValue)
        let gaugeProvider = CLKSimpleGaugeProvider(style: .fill, gaugeColor: .white, fillFraction: 0)
        GetWatchDataUseCase.singleton.getLatestData()
        
        switch complication.family {
        case .circularSmall:
            template = CLKComplicationTemplateCircularSmallSimpleText(textProvider: sgTextProvider)
        case .graphicCircular:
            template = CLKComplicationTemplateGraphicCircularClosedGaugeText(gaugeProvider: gaugeProvider, centerTextProvider: sgTextProvider)
        case .utilitarianLarge:
            template = CLKComplicationTemplateUtilitarianLargeFlat(textProvider: CLKSimpleTextProvider(text: "\(state.sgValue) - \(state.sgTimeOffset)") )
        case .modularSmall:
            template = CLKComplicationTemplateModularSmallSimpleText(textProvider: sgTextProvider)
        case .utilitarianSmall:
            template = CLKComplicationTemplateUtilitarianSmallFlat(textProvider: sgTextProvider)
        case .graphicBezel:
            let circularTemplate = CLKComplicationTemplateGraphicCircularClosedGaugeText(gaugeProvider: gaugeProvider, centerTextProvider: sgTextProvider)
            template = CLKComplicationTemplateGraphicBezelCircularText(circularTemplate: circularTemplate)
        case .graphicCorner:
            template = CLKComplicationTemplateGraphicCornerGaugeText(gaugeProvider: gaugeProvider, outerTextProvider: sgTextProvider)
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
        let sgTextProvider = CLKSimpleTextProvider(text: "---")
        let gaugeProvider = CLKSimpleGaugeProvider(style: .fill, gaugeColor: .white, fillFraction: 0)
        // This method will be called once per supported complication, and the results will be cached
        var template: CLKComplicationTemplate? = nil
        switch complication.family {
        case .circularSmall:
            template = CLKComplicationTemplateCircularSmallSimpleText(textProvider: sgTextProvider)
        case .graphicCircular:
            template = CLKComplicationTemplateGraphicCircularClosedGaugeText(gaugeProvider: gaugeProvider, centerTextProvider: sgTextProvider)
        case .utilitarianLarge:
            template = CLKComplicationTemplateUtilitarianLargeFlat(textProvider: CLKSimpleTextProvider(text: "--- - HACE X min."))
        case .modularSmall:
            template = CLKComplicationTemplateModularSmallSimpleText(textProvider: sgTextProvider)
        case .utilitarianSmall:
            template = CLKComplicationTemplateUtilitarianSmallFlat(textProvider: sgTextProvider)
        case .graphicBezel:
            let circularTemplate = CLKComplicationTemplateGraphicCircularClosedGaugeText(gaugeProvider: gaugeProvider, centerTextProvider: sgTextProvider)
            template = CLKComplicationTemplateGraphicBezelCircularText(circularTemplate: circularTemplate)
        case .graphicCorner:
            template = CLKComplicationTemplateGraphicCornerGaugeText(gaugeProvider: gaugeProvider, outerTextProvider: sgTextProvider)
        default:
            template = nil
        }
        
        handler(template)
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
