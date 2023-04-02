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
    
    func fetchForecastWeather(cityName: String, completion: @escaping(WeatherModel) -> Void) {
        let urlString = "\(baseURL)\(forecastMethod)?key=\(API_KEY)&q=\(cityName)&days=\(numDays)"
        performRequest(with: urlString, completion: completion)
    }
    
    func fetchForecastWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees, completion: @escaping(WeatherModel) -> Void) {
        let urlString = "\(baseURL)\(forecastMethod)?key=\(API_KEY)&q=\(latitude),\(longitude)&days=\(numDays)"
        performRequest(with: urlString, completion: completion)
    }
    
    func performRequest(with urlString: String, completion: @escaping(WeatherModel) -> Void) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!) // TODO: handle this with completion
                    return
                }
                if let safeData = data {
                    if let weather = self.parseJSON(safeData) {
                        print("DEBUG: <performRequest>")
                        completion(weather)
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
                visibility: decodedData.current.vis_miles,
                humidity: decodedData.current.humidity)
            let weather = WeatherModel(
                cityName: decodedData.location.name,
                region: decodedData.location.region,
                country: decodedData.location.country,
                localtime: decodedData.location.localtime_epoch,
                timezone: decodedData.location.tz_id,
                current: current,
                forecast: forecast)
            return weather
        }
        catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
    func fetchSearches(input: String, completion: @escaping(SearchModel) -> Void) {
        let formattedInput = input.replacingOccurrences(of: " ", with: "%20")
        let formattedUrlString = "\(baseURL)\(searchMethod)?key=\(API_KEY)&q=\(formattedInput)"
        performSearchRequest(with: formattedUrlString, completion: completion)
    }
    
    func performSearchRequest(with urlString: String, completion: @escaping(SearchModel) -> Void) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    print("error")
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let results = self.parseSearchJSON(safeData) {
                        completion(results)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseSearchJSON(_ searchData: Data) -> SearchModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode([SearchResultsData].self, from: searchData)
            let results = decodedData.map { result ->
                SearchResultsModel in
                return SearchResultsModel(
                    name: result.name,
                    region: result.region,
                    country: result.country,
                    lat: result.lat,
                    lon: result.lon)
            }
            return results
        }
        catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
