//
//  Helpers.swift
//  weather-app
//
//  Created by Sydney Turner on 10/2/22.
//

import Foundation



func getConditionName(_ conditionCode: Int, _ is_day: Int, withFill: Bool) -> String {
    var conditionName: String {
        switch conditionCode {
        case 1000 where is_day == 1: // Sunny
            return "sun.max"
        case 1000 where is_day == 0: // Clear
            return "moon"
        case 1003 where is_day == 1, 1009 where is_day == 1: // Partly Cloudy, Overcast
            return "cloud.sun"
        case 1003 where is_day == 0, 1006 where is_day == 0, 1009 where is_day == 0: // Partly Cloudy, Overcast, Cloudy
            return "cloud.moon"
        case 1006 where is_day == 1: // Cloudy
            return "cloud"
        case 1030: // Mist
            return "cloud.fog"
        case 1063, 1150, 1153: // Patchy Rain possible, patch light drizzlw
            return "cloud.drizzle"
        case 1183, 1240, 1180: // Light Rain, Light Rain shower, Patchy Light Rain
            return "cloud.rain"
        case 1195, 1243, 1186, 1189, 1192: // Heavy Rain, Moderate or heavy rain shower, Moderate rain
            return "cloud.heavyrain"
        case 1135: // Fog
            return "cloud.fog"
        default:
            return ""
        }
    }
    if (withFill) {
        return conditionName + ".fill"
        // TODO: wht about current cell that already has fill??
    }
    return conditionName
}
