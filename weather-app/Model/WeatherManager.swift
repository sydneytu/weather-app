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
    let API_KEY = WeatherMapApiKey
    
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
    
    func performRequest(with urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let weather = self.parseJSON(safeData) {
                        print(weather.cityName, weather.region)
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let weather = WeatherModel(
                cityName: decodedData.location.name,
                region: decodedData.location.region,
                is_day: decodedData.current.is_day,
                temp: decodedData.current.temp_f,
                condition: decodedData.current.condition.text,
                windMph: decodedData.current.wind_mph,
                feelsLike: decodedData.current.feelslike_f,
                uv: decodedData.current.uv)
            return weather
        }
        catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
