//
//  ComplicationController.swift
//  GlucoseApp WatchKit Extension
//
//  Created by Arnaldo Quintero on 1/11/21.
//

import ClockKit


class ComplicationController: NSObject, CLKComplicationDataSource {
    
    private var model: ViewModelWatch
    
    override init() {
        model = ViewModelWatch()
        super.init()
    }
    
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
        
        Task.init() {
            let login = CareLinkClient(username: "1581862", password: "Candelaria")
            var entry: CLKComplicationTimelineEntry? = nil
            var template: CLKComplicationTemplate? = nil
            if let sg = try? await login.getLastSensorGlucose() {
                let sgValue = "\(sg.lastSG.sg) \(sg.lastSGTrend.icon)"
                print(sgValue)
                
                
                switch complication.family {
                case .circularSmall:
                    // face 2
                    template = CLKComplicationTemplateCircularSmallRingText(textProvider: CLKSimpleTextProvider(text: sgValue), fillFraction: 0.5, ringStyle: .closed)
                case .graphicCircular:
                    //face 1
                    template = CLKComplicationTemplateGraphicCircularStackText(line1TextProvider: CLKSimpleTextProvider(text: sgValue), line2TextProvider: CLKSimpleTextProvider(text: sgValue))
                case .utilitarianLarge:
                    template = CLKComplicationTemplateUtilitarianLargeFlat(textProvider: CLKSimpleTextProvider(text: sgValue) )
                default:
                    handler(nil)
                    return
                }
                entry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template!)
                handler(entry)
            }
        }
        
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
            // face 2
            let template = CLKComplicationTemplateCircularSmallRingText(textProvider: CLKSimpleTextProvider(text: "111"), fillFraction: 0.5, ringStyle: .closed)
            handler(template)
        case .graphicCircular:
            //face 1
            let template = CLKComplicationTemplateGraphicCircularStackText(line1TextProvider: CLKSimpleTextProvider(text: "121"), line2TextProvider: CLKSimpleTextProvider(text: "122"))
            handler(template)
        default:
            handler(nil)
        }
    }
}
