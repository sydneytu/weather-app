//
//  WeatherModel.swift
//  weather-app
//
//  Created by Sydney Turner on 5/8/22.
//

import Foundation
import UIKit

struct WeatherModel {
    let cityName: String
    let region: String
    let current: CurrentModel
    let forecast: [ForecastModel]
    
    var locationString: String {
        return "\(cityName), \(region)"
    }
}

struct CurrentModel {
    let is_day: Int
    let temp: Double
    let condition: String
    let conditionCode: Int
    let windMph: Double
    let feelsLike: Double
    let uv: Double
    
    var tempString: String {
        return "\(String(format: "%.0f", temp))°"
    }
    
    var feelsLikeString: String {
        return "Feels Like \(String(format: "%.0f", feelsLike))°"
    }
    
    var conditionName: String {
        switch conditionCode {
        case 1000 where is_day == 1: // Sunny
            return "sun.max.fill"
        case 1000 where is_day == 0: // Clear
            return "moon.fill"
        case 1003 where is_day == 1, 1009 where is_day == 1: // Partly Cloudy, Overcast
            return "cloud.sun.fill"
        case 1006: // Cloudy
            return "cloud.fill"
        case 1030: // Mist
            return "cloud.fog.fill"
        case 1063: // Patchy Rain possible
            return "cloud.drizzle.fill"
        default:
            return ""
        }
    }
}

struct ForecastModel {
    let days: DaysModel
    let hours: [HoursModel]
}

struct DaysModel {
    let date: String
    let avgTemp: Double
    let maxTemp: Double
    let minTemp: Double
    let conditionCode: Int
    
    var formmattedDay: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        guard let date = dateFormatter.date(from: date) else { return "" }
        dateFormatter.dateFormat = "EEEE"
        let dayOfWeek = dateFormatter.string(from: date)
        return dayOfWeek
    }
    
    var formmattedMaxTemp: String {
        return "\(String(format: "%.0f", maxTemp))°"
    }
    
    var formattedMinTemp: String {
        return "\(String(format: "%.0f", minTemp))°"
    }
    
    var conditionName: String {
        switch conditionCode {
        case 1000: // Sunny, Clear
            return "sun.max"
        case 1003: // Partly Cloudy
            return "cloud.sun"
        case 1006: // Cloudy
            return "cloud"
        case 1009: // Overcast
            return "cloud.sun"
        case 1030: // Mist
            return "cloud.fog"
        case 1063: // Patchy Rain possible
            return "cloud.drizzle"
        default:
            return ""
        }
    }
}

struct HoursModel {
    let time: Int
    let temp: Double
    let is_day: Int
    let condition: String
    let conditionCode: Int
    var isCurrent: Bool
    
    var formattedTime: String {
        let timeString = Date(timeIntervalSince1970: TimeInterval(time))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h a"
        return dateFormatter.string(from: timeString)
    }
    
    var formattedTemp: String {
        return "\(String(format: "%.0f", temp))°"
    }
    
    var timeAsHour: Int {
        let timeString = Date(timeIntervalSince1970: TimeInterval(time))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH"
        return Int(dateFormatter.string(from: timeString))!
    }

    //case 1000 where is_day == 1: // Sunny
    //    return "sun.max.fill"
    //case 1000 where is_day == 0: // Clear
    //    return "moon.fill"
    //case 1003 where is_day == 1, 1009 where is_day == 1: // Partly Cloudy, Overcast
    //    return "cloud.sun.fill"
    //case 1006: // Cloudy
    //    return "cloud.fill"
    //case 1030: // Mist
    //    return "cloud.fog.fill"
    //case 1063: // Patchy Rain possible
    //    return "cloud.drizzle.fill"
    //default:
    //    return ""
    var conditionName: String {
        switch conditionCode {
        case 1000 where is_day == 1: // Sunny, Clear
            return "sun.max"
        case 1003: // Partly Cloudy
            return "cloud.sun"
        case 1006: // Cloudy
            return "cloud"
        case 1009: // Overcast
            return "cloud.sun"
        case 1030: // Mist
            return "cloud.fog"
        case 1063: // Patchy Rain possible
            return "cloud.drizzle"
        default:
            return ""
        }
    }
    
}
