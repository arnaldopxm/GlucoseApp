import SwiftUI
import GlucoseApp_Core

extension GlucoseModel {
    
    public func getColor() -> Color {
        if (value > 180) {
            return ColorsConst.SG_HIGH
        }
        if (value < 70) {
            return ColorsConst.SG_LOW
        }
        return ColorsConst.SG_OK
    }

}
