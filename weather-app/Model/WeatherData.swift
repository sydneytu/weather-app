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
}
