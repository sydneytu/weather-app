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
        hourlyWeatherView.layer.cornerRadius = 25
        return hourlyWeatherView
    }()
    
    private let dailyWeatherView: UIView = {
        let dailyWeatherView = UIView()
        dailyWeatherView.translatesAutoresizingMaskIntoConstraints = false
//        dailyWeatherView.backgroundColor = #colorLiteral(red: 0.752800405, green: 0.7788824439, blue: 0.9847370982, alpha: 0.28)
        dailyWeatherView.backgroundColor = #colorLiteral(red: 0.752800405, green: 0.7788824439, blue: 0.9847370982, alpha: 0.2809135993)
        dailyWeatherView.layer.cornerRadius = 25
        return dailyWeatherView
    }()
    
    private let cityLabel: UILabel = {
        let cityLabel = UILabel()
        cityLabel.text = "Los Angeles, CA"
        cityLabel.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        cityLabel.textColor = .white
        cityLabel.sizeToFit()
        return cityLabel
    }()
    
    private let temperatureLabel: UILabel = {
        let temperatureLabel = UILabel()
        temperatureLabel.text = "78°F"
        temperatureLabel.font = UIFont.systemFont(ofSize: 72, weight: .light)
        temperatureLabel.sizeToFit()
        temperatureLabel.textColor = .white
        return temperatureLabel
    }()
    
    private let dateLabel: UILabel = {
       let dateLabel = UILabel()
        dateLabel.text = "May 8"
        dateLabel.font = UIFont.systemFont(ofSize: 18, weight: .light)
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
        let config = UIImage.SymbolConfiguration(pointSize: 48, weight: .light)
        iv.image = UIImage(systemName: "sun.max", withConfiguration: config)
        iv.clipsToBounds = true
        iv.sizeToFit()
        iv.contentMode = .scaleAspectFit
        iv.tintColor = #colorLiteral(red: 1, green: 0.835642755, blue: 0.3751339912, alpha: 1)
        return iv
    }()
    
    private let conditionDescLabel: UILabel = {
       let label = UILabel()
        label.text = "Partly Cloudy"
        label.font = UIFont.systemFont(ofSize: 18, weight: .light)
        label.sizeToFit()
        label.textColor = .white
        return label
        
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
    
    private var hourlyCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 1, left: 0, bottom: 1, right: 0)
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(HourCell.self, forCellWithReuseIdentifier: "hourCell")
        cv.isScrollEnabled = true
        cv.backgroundColor = UIColor.black.withAlphaComponent(0)
        return cv
    }()
    
    var heightConstraint:[NSLayoutConstraint]?
    
    let locationManager = CLLocationManager()
    var weatherManager = WeatherManager()

    override func viewDidLoad() {
        super.viewDidLoad()
    
        weatherManager.delegate = self
        locationManager.delegate = self
        hourlyCollectionView.dataSource = self
        hourlyCollectionView.delegate = self
        
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
        createCurrentWeatherView()
        createHourlyWeatherView()
        createDailyWeatherView()
        
        // searchView
        let searchStackView = UIStackView(arrangedSubviews: [currentLocationButton, cityLabel, searchButton])
        searchStackView.translatesAutoresizingMaskIntoConstraints = false
        searchStackView.axis = .horizontal
        searchStackView.distribution = .equalSpacing
        searchStackView.layoutMargins = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        searchStackView.isLayoutMarginsRelativeArrangement = true
        
        // mainStackView
        let mainStackView = UIStackView(arrangedSubviews: [searchStackView, currentWeatherView, hourlyWeatherView, dailyWeatherView])
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.axis = .vertical
        mainStackView.spacing = 10
        mainStackView.distribution = .fill
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
        ])
    }
    
    func createCurrentWeatherView() {
        let currentWeatherInfoStackView = UIStackView(arrangedSubviews: [temperatureLabel, feelsLikeLabel ,dateLabel])
        currentWeatherInfoStackView.translatesAutoresizingMaskIntoConstraints = false
        currentWeatherInfoStackView.axis = .vertical
        
        let conditionStackView = UIStackView(arrangedSubviews: [conditionImageView, conditionDescLabel])
        conditionStackView.translatesAutoresizingMaskIntoConstraints = false
        conditionStackView.axis = .vertical
        conditionStackView.distribution = .fillProportionally
        
        let currentWeatherStackView = UIStackView(arrangedSubviews: [currentWeatherInfoStackView, conditionStackView])
        currentWeatherStackView.translatesAutoresizingMaskIntoConstraints = false
        currentWeatherStackView.axis = .horizontal
        currentWeatherStackView.distribution = .equalSpacing
        currentWeatherView.addSubview(currentWeatherStackView)
        
        NSLayoutConstraint.activate([
            currentWeatherStackView.leadingAnchor.constraint(equalTo: currentWeatherView.leadingAnchor, constant: 20),
            currentWeatherStackView.trailingAnchor.constraint(equalTo: currentWeatherView.trailingAnchor, constant: -20),
            currentWeatherStackView.topAnchor.constraint(equalTo: currentWeatherView.topAnchor, constant: 10),
            currentWeatherStackView.bottomAnchor.constraint(equalTo: currentWeatherView.bottomAnchor, constant: -10)
        ])
    }
    
    func createHourlyWeatherView() {
        let view = UIStackView(arrangedSubviews: [hourlyCollectionView])
        view.translatesAutoresizingMaskIntoConstraints = false
        hourlyWeatherView.addSubview(view)
        
        hourlyCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: hourlyWeatherView.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: hourlyWeatherView.trailingAnchor),
            view.topAnchor.constraint(equalTo: hourlyWeatherView.topAnchor, constant: 10),
            view.bottomAnchor.constraint(equalTo: hourlyWeatherView.bottomAnchor, constant: -10),
            hourlyWeatherView.heightAnchor.constraint(equalToConstant: 150)
        ])
    }
    
    func createDailyWeatherView() {
        dailyWeatherView.translatesAutoresizingMaskIntoConstraints = false
        
        let temp = UILabel()
        temp.text = "temporary"
        temp.textColor = .yellow
        temp.font = UIFont.systemFont(ofSize: 72, weight: .regular)
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.sizeToFit()
        dailyWeatherView.addSubview(temp)
        // create table view
        
    }
}

// MARK: - WeatherManagerDelegate
extension WeatherViewController: WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        DispatchQueue.main.async {
            self.cityLabel.text = "\(weather.cityName)"
            self.temperatureLabel.text = weather.current.tempString
            self.feelsLikeLabel.text = weather.current.feelsLikeString
            self.conditionDescLabel.text = weather.current.condition
        }
    }
    
    func didFailWithError(error: Error) {
        // TODO: show alert saying could not get weather
        print(error)
    }
}

// MARK: - CLLocationManagerDelegate
extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.fetchForecastWeather(latitude: lat, longitude: lon)
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: \(error)")
    }
}

// MARK: - UICollectionViewDataSource
extension WeatherViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = hourlyCollectionView.dequeueReusableCell(withReuseIdentifier: "hourCell", for: indexPath) as? HourCell else {
            fatalError("Unable to dequeue hourCell.")
        }
        return cell
    }
    
}

// MARK: - UICollectionViewDelegate
extension WeatherViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // nothing
    }
    
}

extension WeatherViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = hourlyCollectionView.bounds.size.width / CGFloat(4.5)
        return CGSize(width: width, height: hourlyCollectionView.bounds.size.height - 5)

    }
    
}
