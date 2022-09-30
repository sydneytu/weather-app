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
        mainView.backgroundColor = #colorLiteral(red: 0.9138072133, green: 0.9178827405, blue: 0.9283933043, alpha: 1)
        return mainView
    }()
    
    private let currentWeatherView: UIView = {
        let currentWeatherView = UIView()
        currentWeatherView.configureUIView()
        return currentWeatherView
    }()
    
    private let hourlyWeatherView: UIView = {
        let hourlyWeatherView = UIView()
        hourlyWeatherView.configureUIView()
        return hourlyWeatherView
    }()
    
    private let dailyWeatherView: UIView = {
        let dailyWeatherView = UIView()
        dailyWeatherView.configureUIView()
        dailyWeatherView.backgroundColor = #colorLiteral(red: 1, green: 0.9999999404, blue: 1, alpha: 1)
        return dailyWeatherView
    }()
    
    private let cityLabel: UILabel = {
        let cityLabel = UILabel()
        cityLabel.configureLabel(size: 20, weight: .regular, text: "")
        cityLabel.textColor = .black
        return cityLabel
    }()
    
    private let temperatureLabel: UILabel = {
        let temperatureLabel = UILabel()
        temperatureLabel.configureLabel(size: 72, weight: .light, text: "78°")
        return temperatureLabel
    }()
    
    private let dateLabel: UILabel = {
       let dateLabel = UILabel()
        dateLabel.configureLabel(size: 18, weight: .light, text: "May 8")
        return dateLabel
    }()
    
    private let feelsLikeLabel: UILabel = {
        let label = UILabel()
        label.configureLabel(size: 18, weight: .light, text: "Feels Like 75°")
        return label
    }()
    
    private let conditionImageView: UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.sizeToFit()
        iv.contentMode = .scaleAspectFit
        iv.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        return iv
    }()
    
    private let conditionDescLabel: UILabel = {
        let label = UILabel()
        label.configureLabel(size: 18, weight: .light, text: "Partly Cloudy")
        return label
    }()
    
    private let currentLocationButton: UIButton = {
       let bt = UIButton()
        bt.setImage(UIImage(systemName: "location"), for: .normal)
        bt.sizeToFit()
        bt.tintColor = .black
        bt.addTarget(self, action: #selector(userLocationButtonPressed), for: .touchUpInside)
        return bt
    }()
    
    private let searchButton: UIButton = {
       let bt = UIButton()
        bt.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        bt.sizeToFit()
        bt.tintColor = .black
        bt.addTarget(self, action: #selector(searchButtonPressed), for: .touchUpInside)
        return bt
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
    
    private var dailyTableView: UITableView = {
        let tv = UITableView()
        tv.register(DailyCell.self, forCellReuseIdentifier: "dailyCell")
        tv.backgroundColor = UIColor.black.withAlphaComponent(0)
        return tv
    }()
    
    var hoursWeatherArr = [HoursModel]()
    var dailyWeatherArr = [ForecastModel]()
    let locationManager = CLLocationManager()
    var weatherManager = WeatherManager()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    
        weatherManager.delegate = self
        locationManager.delegate = self
        hourlyCollectionView.dataSource = self
        hourlyCollectionView.delegate = self
        dailyTableView.dataSource = self
        dailyTableView.delegate = self
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        view.backgroundColor = #colorLiteral(red: 0.9138072133, green: 0.9178827405, blue: 0.9283933043, alpha: 1)
        createMainView()
    }
    
    // MARK: - Actions
    @objc func userLocationButtonPressed() {
        locationManager.requestLocation()
    }
    
    // TODO: change name of function to something about going to next screen (show up)
    @objc func searchButtonPressed() {
        print("pressed")
        let controller = SearchController()
        controller.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        present(controller, animated: true)
    }
    
    // MARK: - Helpers
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
        
        NSLayoutConstraint.activate([
            // mainView
            mainView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            mainView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            mainView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            mainStackView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 10),
            mainStackView.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -10),
            mainStackView.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 10),
            mainStackView.bottomAnchor.constraint(equalTo: mainView.bottomAnchor, constant: 10),
        ])
    }
    
    func createCurrentWeatherView() {
        let backgroundImage = UIImageView(frame: currentWeatherView.bounds)
        backgroundImage.configureUIView()
        backgroundImage.clipsToBounds = true
        backgroundImage.image = #imageLiteral(resourceName: "current-weather-bg")
        backgroundImage.contentMode = .scaleToFill
        backgroundImage.translatesAutoresizingMaskIntoConstraints = false
        currentWeatherView.insertSubview(backgroundImage, at: 0)
        
        NSLayoutConstraint.activate([
            backgroundImage.heightAnchor.constraint(equalToConstant: 175),
            backgroundImage.leadingAnchor.constraint(equalTo: currentWeatherView.leadingAnchor),
            backgroundImage.trailingAnchor.constraint(equalTo: currentWeatherView.trailingAnchor),
            backgroundImage.topAnchor.constraint(equalTo: currentWeatherView.topAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: currentWeatherView.bottomAnchor)
        ])
        
        
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
        let view = UIStackView(arrangedSubviews: [dailyTableView])
        view.translatesAutoresizingMaskIntoConstraints = false
        dailyWeatherView.addSubview(view)
        dailyWeatherView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: dailyWeatherView.leadingAnchor, constant: 5),
            view.trailingAnchor.constraint(equalTo: dailyWeatherView.trailingAnchor, constant: -5),
            view.topAnchor.constraint(equalTo: dailyWeatherView.topAnchor, constant: 10),
            view.bottomAnchor.constraint(equalTo: dailyWeatherView.bottomAnchor, constant: -10)
        ])
    }
    
    func time24() -> Int {
        let time = Date()
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH"
        return Int(timeFormatter.string(from: time))!
    }
    
    func scrollToCurrentHour() {
        self.hourlyCollectionView.scrollToItem(at: IndexPath(item: time24(), section: 0), at: UICollectionView.ScrollPosition.centeredHorizontally, animated: false)
    }
    
    func isCurrentTime(cellTime: Int) -> Bool {
        return time24() == cellTime ? true : false
    }
}

// MARK: - WeatherManagerDelegate
extension WeatherViewController: WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        DispatchQueue.main.async {
            self.cityLabel.text = "\(weather.locationString)"
            self.temperatureLabel.text = weather.current.tempString
            self.feelsLikeLabel.text = weather.current.feelsLikeString
            self.conditionDescLabel.text = weather.current.condition
            self.dateLabel.text = weather.forecast.first?.days.formmattedDay
            
            let config = UIImage.SymbolConfiguration(pointSize: 48, weight: .light)
            self.conditionImageView.image = UIImage(systemName: weather.current.conditionName, withConfiguration: config)
            
            if let hours = weather.forecast.first?.hours {
                self.hoursWeatherArr = hours
            }
            self.dailyWeatherArr = weather.forecast
            self.dailyTableView.reloadData()
            
            self.hourlyCollectionView.reloadData()
            self.scrollToCurrentHour()
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
        return hoursWeatherArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = hourlyCollectionView.dequeueReusableCell(withReuseIdentifier: "hourCell", for: indexPath) as? HourCell else {
            fatalError("Unable to dequeue hourCell.")
        }
        if self.hoursWeatherArr.count > 0 {
            var hour = self.hoursWeatherArr[indexPath.item]
            cell.temp = hour.formattedTemp
            cell.time = hour.formattedTime
            cell.conditionName = hour.conditionName
            hour.isCurrent = isCurrentTime(cellTime: hour.timeAsHour) ? true : false
            cell.isCurrentCell = hour.isCurrent
        }
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension WeatherViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = hourlyCollectionView.bounds.size.width / CGFloat(5)
        return CGSize(width: width, height: hourlyCollectionView.bounds.size.height - 5)
    }
}

// MARK: - UITableViewDatasource
extension WeatherViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dailyWeatherArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "dailyCell", for: indexPath) as? DailyCell else {
            fatalError("Unable to dequeue DailyCell")
        }
        if self.dailyWeatherArr.count > 0 {
            let day = self.dailyWeatherArr[indexPath.row].days
            cell.dayOfWeek = day.formmattedDay
            cell.maxTemp = day.formmattedMaxTemp
            cell.minTemp = day.formattedMinTemp
            cell.conditionName = day.conditionName
        }
        return cell
    }
}

// MARK: - UITableViewDelegate
extension WeatherViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // do nothing
    }
}
