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
        case 1000: // Sunny, Clear
            return "sun.max.fill"
        case 1003: // Partly Cloudy
            return "cloud.sun.fill"
        case 1006: // Cloudy
            return "cloud.fill"
        case 1009: // Overcast
            return ""
        case 1030: // Mist
            return ""
        case 1063: // Patchy Rain possible
            return ""
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
}

struct HoursModel {
    let time: Int
    let temp: Double
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
}
