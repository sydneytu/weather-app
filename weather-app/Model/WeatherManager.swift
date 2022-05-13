//
//  WeatherManager.swift
//  weather-app
//
//  Created by Sydney Turner on 5/8/22.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager {
    let baseURL = "https://api.weatherapi.com/v1"
    let currentMethod = "/current.json"
    let forecastMethod = "/forecast.json"
    let API_KEY = WeatherMapApiKey
    let numDays = 2
    
    //https://api.weatherapi.com/v1/forecast.json?key=439755fbecda4ef7833184340220805&q=Richmond&days=1
    
    var delegate: WeatherManagerDelegate?
    
    func fetchCurrentWeather(cityName: String) {
        let urlString = "\(baseURL)\(currentMethod)?key=\(API_KEY)&q=\(cityName)"
        performRequest(with: urlString)
    }
    
    func fetchCurrentWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let urlString = "\(baseURL)\(currentMethod)?key=\(API_KEY)&q=\(latitude),\(longitude)"
        print(urlString)
        performRequest(with: urlString)
    }
    
    func fetchForecastWeather(cityName: String) {
        let urlString = "\(baseURL)\(forecastMethod)?key=\(API_KEY)&q=\(cityName)&days=\(numDays)"
        performRequest(with: urlString)
    }
    
    func fetchForecastWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees){
        let urlString = "\(baseURL)\(forecastMethod)?key=\(API_KEY)&q=\(latitude),\(longitude)&days=\(numDays)"
        print(urlString)
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    self.parseJSON(safeData)
//                    if let weather = self.parseJSON(safeData) {
//                        print(weather.cityName, weather.region)
//                        self.delegate?.didUpdateWeather(self, weather: weather)
//                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            print(decodedData.forecast.forecastday[0].hour.first?.condition.text as Any)
            let current = CurrentModel(
                is_day: decodedData.current.is_day,
                temp: decodedData.current.temp_f,
                condition: decodedData.current.condition.text,
                windMph: decodedData.current.wind_mph,
                feelsLike: decodedData.current.feelslike_f,
                uv: decodedData.current.uv)
            let days = DaysModel(
                date: decodedData.forecast.forecastday.date,
                avgTemp: decodedData.forecast.forecastday.day.avgtemp_f)
//            let hours = HoursModel(
//                time: decodedData.forecast.forecastday.hour.time,
//                temp: decodedData.forecast.forecastday.hour.temp_f,
//                condition: decodedData.forecast.forecastday.hour.condition)
//            let forecast = ForecastModel(
//                days: days,
//                hours: hours)
//            let weather = WeatherModel(
//                cityName: decodedData.location.name,
//                region: decodedData.location.region,
//                current: current, forcast: forecast)
//            return weather
        }
        catch {
            delegate?.didFailWithError(error: error)
//            return nil
        }
    }
}
