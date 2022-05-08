//
//  ViewController.swift
//  weather-app
//
//  Created by Sydney Turner on 5/7/22.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    
    private let mainView: UIView = {
        let mainView = UIView()
        mainView.translatesAutoresizingMaskIntoConstraints = false
        mainView.backgroundColor = #colorLiteral(red: 0.2705882353, green: 0.3215686275, blue: 0.768627451, alpha: 1)
        return mainView
    }()
    
    private let currentWeatherView: UIView = {
        let currentWeatherView = UIView()
        currentWeatherView.translatesAutoresizingMaskIntoConstraints = false
        currentWeatherView.backgroundColor = #colorLiteral(red: 0.752800405, green: 0.7788824439, blue: 0.9847370982, alpha: 0.2809135993)
        currentWeatherView.layer.cornerRadius = 25
        return currentWeatherView
    }()
    
    private let hourlyWeatherView: UIView = {
        let hourlyWeatherView = UIView()
        hourlyWeatherView.translatesAutoresizingMaskIntoConstraints = false
        hourlyWeatherView.backgroundColor = #colorLiteral(red: 0.752800405, green: 0.7788824439, blue: 0.9847370982, alpha: 0.28)
        hourlyWeatherView.layer.cornerRadius = 25
        return hourlyWeatherView
    }()
    
//    private let dailyWeatherView: UIView = {
//        let dailyWeatherView = UIView()
//        dailyWeatherView.translatesAutoresizingMaskIntoConstraints = false
//        dailyWeatherView.backgroundColor = .purple
//        dailyWeatherView.layer.cornerRadius = 25
//        return dailyWeatherView
//    }()
    
    private let cityLabel: UILabel = {
        let cityLabel = UILabel()
        cityLabel.text = "Los Angeles, CA"
        cityLabel.font = UIFont.systemFont(ofSize: 20, weight: .regular)
//        cityLabel.backgroundColor = .green
        cityLabel.textColor = .white
        cityLabel.sizeToFit()
        return cityLabel
    }()
    
    private let temperatureLabel: UILabel = {
        let temperatureLabel = UILabel()
        temperatureLabel.text = "78°F"
        temperatureLabel.font = UIFont.systemFont(ofSize: 72, weight: .light)
//        temperatureLabel.backgroundColor = .link
        temperatureLabel.sizeToFit()
        temperatureLabel.textColor = .white
        return temperatureLabel
    }()
    
    private let dateLabel: UILabel = {
       let dateLabel = UILabel()
        dateLabel.text = "May 8"
        dateLabel.font = UIFont.systemFont(ofSize: 18, weight: .light)
//        dateLabel.backgroundColor = .cyan
        dateLabel.sizeToFit()
        dateLabel.textColor = .white
        return dateLabel
    }()
    
    private let feelsLikeLabel: UILabel = {
        let label = UILabel()
        label.text = "Feels Like 75°"
        label.font = UIFont.systemFont(ofSize: 18, weight: .light)
        label.sizeToFit()
        label.textColor = .white
        return label
    }()
    
    private let conditionImageView: UIImageView = {
        let iv = UIImageView()
        let config = UIImage.SymbolConfiguration(pointSize: 56, weight: .light)
        iv.image = UIImage(systemName: "sun.max", withConfiguration: config)
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFit
        iv.tintColor = #colorLiteral(red: 1, green: 0.835642755, blue: 0.3751339912, alpha: 1)
        return iv
    }()
    
    private let currentLocationButton: UIButton = {
       let button = UIButton()
        button.setImage(UIImage(systemName: "location"), for: .normal)
        button.sizeToFit()
        button.tintColor = .white
        button.addTarget(self, action: #selector(userLocationButtonPressed), for: .touchUpInside)
        return button
    }()
    
    private let searchButton: UIButton = {
       let searchButton = UIButton()
        searchButton.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        searchButton.sizeToFit()
        searchButton.tintColor = .white
        return searchButton
    }()
    
    let locationManager = CLLocationManager()
    let weatherManager = WeatherManager()

    override func viewDidLoad() {
        super.viewDidLoad()
    
        locationManager.delegate = self
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        view.backgroundColor = #colorLiteral(red: 0.2705882353, green: 0.3215686275, blue: 0.768627451, alpha: 1)
        createMainView()
    }
    
    @objc func userLocationButtonPressed() {
        locationManager.requestLocation()
    }
    
    func createMainView() {
        view.addSubview(mainView)
        
        // searchView
        let searchStackView = UIStackView(arrangedSubviews: [currentLocationButton, cityLabel, searchButton])
        searchStackView.translatesAutoresizingMaskIntoConstraints = false
        searchStackView.axis = .horizontal
        searchStackView.distribution = .equalSpacing
//        searchStackView.backgroundColor = #colorLiteral(red: 0.752800405, green: 0.7788824439, blue: 0.9847370982, alpha: 0.2809135993)
        searchStackView.layoutMargins = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        searchStackView.isLayoutMarginsRelativeArrangement = true
        mainView.addSubview(searchStackView)
        
        // currentWeatherView
        let currentWeatherInfoStackView = UIStackView(arrangedSubviews: [temperatureLabel, feelsLikeLabel ,dateLabel])
        currentWeatherInfoStackView.translatesAutoresizingMaskIntoConstraints = false
        currentWeatherInfoStackView.axis = .vertical
//        currentWeatherStackView.backgroundColor = .blue
        
        
        let currentWeatherStackView = UIStackView(arrangedSubviews: [currentWeatherInfoStackView, conditionImageView])
        currentWeatherStackView.translatesAutoresizingMaskIntoConstraints = false
        currentWeatherStackView.axis = .horizontal
        currentWeatherStackView.distribution = .fillProportionally
        currentWeatherView.addSubview(currentWeatherStackView)
        
        // mainStackView
        let mainStackView = UIStackView(arrangedSubviews: [searchStackView, currentWeatherView, hourlyWeatherView])
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.axis = .vertical
        mainStackView.spacing = 10
        mainStackView.distribution = .fill
//        mainStackView.backgroundColor = .red
        mainView.addSubview(mainStackView)
        
        // activate constraints
        NSLayoutConstraint.activate([
            // mainView
            mainView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            mainView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            mainView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            // main stack view
            mainStackView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 10),
            mainStackView.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -10),
            mainStackView.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 10),
            mainStackView.bottomAnchor.constraint(equalTo: mainView.bottomAnchor, constant: 10),
            
            // currentWeatherStackView
            currentWeatherStackView.leadingAnchor.constraint(equalTo: currentWeatherView.leadingAnchor, constant: 20),
            currentWeatherStackView.trailingAnchor.constraint(equalTo: currentWeatherView.trailingAnchor, constant: -20),
            currentWeatherStackView.topAnchor.constraint(equalTo: currentWeatherView.topAnchor, constant: 10),
            currentWeatherStackView.bottomAnchor.constraint(equalTo: currentWeatherView.bottomAnchor, constant: -10)
            
        ])
    }
}

// MARK: - CLLocationManagerDelegate
extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.fetchCurrentWeather(latitude: lat, longitude: lon)
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: \(error.localizedDescription)")
    }
}

