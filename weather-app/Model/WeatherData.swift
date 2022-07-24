//
//  WeatherData.swift
//  weather-app
//
//  Created by Sydney Turner on 5/8/22.
//

import Foundation

struct WeatherData: Codable {
    let location: Location
    let current: Current
    let forecast: Forecast
}

struct Location: Codable {
    let name: String
    let region: String
}

struct Current: Codable {
    let temp_f: Double
    let is_day: Int
    let condition: Condition
    let wind_mph: Double
    let humidity: Double
    let feelslike_f: Double
    let uv: Double
}

struct Condition: Codable {
    let text: String
    let code: Int
}

struct Forecast: Codable {
    let forecastday: [ForecastDay]
}

struct ForecastDay: Codable {
    let date: String
    let day: Day
    let hour: [Hour]
}

struct Day: Codable {
    let avgtemp_f: Double
    let maxtemp_f: Double
    let mintemp_f: Double
    let condition: Condition
}

struct Hour: Codable {
    let time_epoch: Int
    let temp_f: Double
    let condition: Condition
}
