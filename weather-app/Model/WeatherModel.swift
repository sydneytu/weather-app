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
    let country: String
    let localtime: Int
    let timezone: String
    let current: CurrentModel
    let forecast: [ForecastModel]
    
    var locationString: String {
        return "\(cityName), \(region)"
    }
    
    var formattedLocalTime: String {
        let timeString = Date(timeIntervalSince1970: TimeInterval(localtime))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h a"
        dateFormatter.timeZone = TimeZone(identifier: timezone)
        return dateFormatter.string(from: timeString)
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
    let visibility: Double
    let humidity: Double
    
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
        case 1003 where is_day == 0, 1006 where is_day == 0, 1009 where is_day == 0: // Partly Cloudy, Overcast, Cloudy
            return "cloud.moon.fill"
        case 1006 where is_day == 1: // Cloudy
            return "cloud.fill"
        case 1030: // Mist
            return "cloud.fog.fill"
        case 1063, 1150, 1153: // Patchy Rain possible, patch light drizzlw
            return "cloud.drizzle.fill"
        case 1183, 1240, 1180: // Light Rain, Light Rain shower, Patchy Light Rain
            return "cloud.rain.fill"
        case 1195, 1243, 1186, 1189, 1192: // Heavy Rain, Moderate or heavy rain shower, Moderate rain
            return "cloud.heavyrain.fill"
        case 1135: // Fog
            return "cloud.fog.fill"
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
    
    var conditionName: String {
        switch conditionCode {
        case 1000: // Sunny
            return "sun.max"
        case 1003, 1009: // Partly Cloudy, Overcast
            return "cloud.sun"
        case 1006: // Cloudy
            return "cloud"
        case 1030: // Mist
            return "cloud.fog"
        case 1063, 1150, 1153: // Patchy Rain possible, patch light drizzlw
            return "cloud.drizzle"
        case 1183, 1240, 1180: // Light Rain, Light Rain shower, Patchy Light Rain
            return "cloud.rain"
        case 1195, 1243, 1186, 1189, 1192, 1258: // Heavy Rain, Moderate or heavy rain shower, Moderate rain
            return "cloud.heavyrain"
        case 1135: // Fog
            return "cloud.fog"
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
    
    var timeAsHour: Int {
        let timeString = Date(timeIntervalSince1970: TimeInterval(time))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH"
        return Int(dateFormatter.string(from: timeString))!
    }

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
        case 1195, 1243, 1186, 1189, 1192, 1258: // Heavy Rain, Moderate or heavy rain shower, Moderate rain
            return "cloud.heavyrain"
        case 1135: // Fog
            return "cloud.fog"
        default:
            return ""
        }
    }
    
}
