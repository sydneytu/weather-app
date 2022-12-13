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
    let searchMethod = "/search.json"
    let API_KEY = WeatherMapApiKey
    let numDays = 3
    
    var delegate: WeatherManagerDelegate?
    
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
            
            let forecast = decodedData.forecast.forecastday.map { forecastDay -> ForecastModel in
                let day  = DaysModel(date: forecastDay.date, avgTemp: forecastDay.day.avgtemp_f, maxTemp: forecastDay.day.maxtemp_f, minTemp: forecastDay.day.mintemp_f, conditionCode: forecastDay.day.condition.code)
                
                let hours = forecastDay.hour.map { hour in
                    return HoursModel(time: hour.time_epoch, temp: hour.temp_f, is_day: hour.is_day, condition: hour.condition.text, conditionCode: hour.condition.code, isCurrent: false)
                }
                return ForecastModel(days: day, hours: hours)
            }
            
            let current = CurrentModel(
                is_day: decodedData.current.is_day,
                temp: decodedData.current.temp_f,
                condition: decodedData.current.condition.text,
                conditionCode: decodedData.current.condition.code,
                windMph: decodedData.current.wind_mph,
                feelsLike: decodedData.current.feelslike_f,
                uv: decodedData.current.uv,
                visibility: decodedData.current.vis_miles)
            let weather = WeatherModel(
                cityName: decodedData.location.name,
                region: decodedData.location.region,
                current: current,
                forecast: forecast)
            return weather
        }
        catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
    func fetchSearches(input: String) {
        let urlString = "\(baseURL)\(searchMethod)?key=\(API_KEY)=\(input)"
        performSearchRequest(with: urlString)
    }
    
    func performSearchRequest(with urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    print("error")
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    print("here")
//                    if let results = self.parseSearchJSON(safeData) {
                        // populate search results page
//                    }
                }
            }
            task.resume()
            
        }
    }
    
//    func parseSearchJSON(_ searchData: Data) -> SearchModel? {
//        let decoder = JSONDecoder()
//        do {
//            let decodedData = try decoder.decode(Searches.self, from: searchData)
//            let results = decodedData. { result ->
//                SearchResultsModel in
//                print(result.name, result.region)
////                return SearchResultsModel(name: result.name, region: result.region, lat: result.lat, lon: result.lon)
//            }
////            return SearchModel(searchResults: results)
//        }
//        catch {
//            delegate?.didFailWithError(error: error)
//            return nil
//        }
//    }
}
