//
//  WeatherModel.swift
//  weather-app
//
//  Created by Sydney Turner on 5/8/22.
//

import Foundation

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
    let windMph: Double
    let feelsLike: Double
    let uv: Double
    
    var tempString: String {
        return "\(String(format: "%.0f", temp))°F"
    }
    
    var feelsLikeString: String {
        return "Feels Like \(String(format: "%.0f", feelsLike))°"
    }
}

struct ForecastModel {
    let days: DaysModel
    let hours: [HoursModel]
}

struct DaysModel {
    let date: String
    let avgTemp: Double
}

struct HoursModel {
    let time: Int
    let temp: Double
    let condition: String
    
    var formattedTime: String {
        let timeString = Date(timeIntervalSince1970: TimeInterval(time))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h a"
        return dateFormatter.string(from: timeString)
    }
    
    var formattedTemp: String {
        return "\(String(format: "%.0f", temp))°F"
    }
}
