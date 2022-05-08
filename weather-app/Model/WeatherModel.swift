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
