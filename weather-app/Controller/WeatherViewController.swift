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
    
    private let temperatureLabel: UILabel = {
        let temperatureLabel = UILabel()
        temperatureLabel.textAlignment = .center
        temperatureLabel.configureLabel(size: 84, weight: .light, text: "78°")
        return temperatureLabel
    }()
    
    private let dateLabel: UILabel = {
       let dateLabel = UILabel()
        dateLabel.textAlignment = .center
        dateLabel.configureLabel(size: 14, weight: .regular, text: "May 8")
        dateLabel.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        return dateLabel
    }()
    
    private let feelsLikeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
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
        label.textAlignment = .center
        label.configureLabel(size: 18, weight: .regular, text: "Partly Cloudy")
        return label
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
    
    private var otherInfoView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let uvIndexLabel: UILabel = {
        let label = UILabel()
        label.configureLabel(size: 20, weight: .regular, text: "1")
        label.textAlignment = .center
        return label
    }()
    
    private let windMphLabel: UILabel = {
        let label = UILabel()
        label.configureLabel(size: 20, weight: .regular, text: "2.2 m/h")
        label.textAlignment = .center
        return label
    }()
    
    private let humidityLabel: UILabel = {
        let label = UILabel()
        label.configureLabel(size: 20, weight: .regular, text: "55%")
        label.textAlignment = .center
        return label
    }()
    
    private let visibilityLabel: UILabel = {
        let label = UILabel()
        label.configureLabel(size: 20, weight: .regular, text: "9 mi")
        label.textAlignment = .center
        return label
    }()
    
    var hoursWeatherArr = [HoursModel]()
    var dailyWeatherArr = [ForecastModel]()
    let locationManager = CLLocationManager()
    var weatherManager = WeatherManager()
    let searchController = UISearchController(searchResultsController: SearchResultsController())

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    
        weatherManager.delegate = self
        locationManager.delegate = self
        hourlyCollectionView.dataSource = self
        hourlyCollectionView.delegate = self
        dailyTableView.dataSource = self
        dailyTableView.delegate = self
        
        let searchResultsController = self.storyboard?.instantiateViewController(withIdentifier: "SearchResultsController") as? SearchResultsController
        searchResultsController?.tableView.delegate = self
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = true
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Enter city"
        
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "location"), style: .plain, target: self, action: #selector(userLocationButtonPressed))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: #selector(searchButtonPressed))
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: .regular)]

        definesPresentationContext = true
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        view.backgroundColor = #colorLiteral(red: 0.9138072133, green: 0.9178827405, blue: 0.9283933043, alpha: 1)
        createMainView()
    }
    
    // MARK: - Actions
    @objc func userLocationButtonPressed() {
        locationManager.requestLocation()
    }
    
    @objc func searchButtonPressed() {
        present(searchController, animated: true)
    }
    
    // MARK: - Helpers
    func createMainView() {
        view.addSubview(mainView)
        createCurrentWeatherView()
        createHourlyWeatherView()
        createDailyWeatherView()
        
        // mainStackView
        let mainStackView = UIStackView(arrangedSubviews: [currentWeatherView,hourlyWeatherView, dailyWeatherView])
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
            backgroundImage.heightAnchor.constraint(equalToConstant: 425),
            backgroundImage.leadingAnchor.constraint(equalTo: currentWeatherView.leadingAnchor),
            backgroundImage.trailingAnchor.constraint(equalTo: currentWeatherView.trailingAnchor),
            backgroundImage.topAnchor.constraint(equalTo: currentWeatherView.topAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: currentWeatherView.bottomAnchor)
        ])
        
//        let currentWeatherInfoStackView = UIStackView(arrangedSubviews: [temperatureLabel, feelsLikeLabel, dateLabel])
//        currentWeatherInfoStackView.translatesAutoresizingMaskIntoConstraints = false
//        currentWeatherInfoStackView.setCustomSpacing(10.0, after: temperatureLabel)
//        currentWeatherInfoStackView.axis = .vertical
        
        let conditionStackView = UIStackView(arrangedSubviews: [conditionImageView, conditionDescLabel, dateLabel, temperatureLabel])
        conditionStackView.translatesAutoresizingMaskIntoConstraints = false
        conditionStackView.axis = .vertical
        conditionStackView.distribution = .fillProportionally
        conditionStackView.setCustomSpacing(-30.0, after: dateLabel)
        
//        let currentWeatherStackView = UIStackView(arrangedSubviews: [currentWeatherInfoStackView, conditionStackView])
//        currentWeatherStackView.translatesAutoresizingMaskIntoConstraints = false
//        currentWeatherStackView.axis = .horizontal
//        currentWeatherStackView.distribution = .equalSpacing
        
        createOtherInfoView()
//        let separator = UIView()
//        separator.translatesAutoresizingMaskIntoConstraints = false
//        separator.backgroundColor = .white
        
        let stackView = UIStackView(arrangedSubviews: [conditionStackView, otherInfoView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        currentWeatherView.addSubview(stackView)
        
        stackView.setCustomSpacing(20.0, after: conditionStackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: currentWeatherView.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: currentWeatherView.trailingAnchor, constant: -20),
            stackView.topAnchor.constraint(equalTo: currentWeatherView.topAnchor, constant: 10),
            stackView.bottomAnchor.constraint(equalTo: currentWeatherView.bottomAnchor, constant: -10),
//            separator.heightAnchor.constraint(equalToConstant: 1)
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
    
    func createOtherInfoView() {
        otherInfoView.translatesAutoresizingMaskIntoConstraints = false
        let uvTextLabel = UILabel()
        uvTextLabel.configureLabel(size: 12, weight: .regular, text: "UV Index")
        uvTextLabel.textAlignment = .center
        uvTextLabel.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        let uvView = UIStackView(arrangedSubviews: [uvIndexLabel, uvTextLabel])
        uvView.axis = .vertical
        
        let visibilityTextLabel = UILabel()
        visibilityTextLabel.configureLabel(size: 12, weight: .regular, text: "Visibility")
        visibilityTextLabel.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        visibilityTextLabel.textAlignment = .center
        let visibilityView = UIStackView(arrangedSubviews: [visibilityLabel, visibilityTextLabel])
        visibilityView.axis = .vertical
        
        let humidityTextLabel = UILabel()
        humidityTextLabel.configureLabel(size: 12, weight: .regular, text: "Humidity")
        humidityTextLabel.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        humidityTextLabel.textAlignment = .center
        let humidityView = UIStackView(arrangedSubviews: [humidityLabel, humidityTextLabel])
        humidityView.axis = .vertical
        
        let windMphTextLabel = UILabel()
        windMphTextLabel.configureLabel(size: 12, weight: .regular, text: "Wind")
        windMphTextLabel.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        windMphTextLabel.textAlignment = .center
        let windMphView = UIStackView(arrangedSubviews: [windMphLabel, windMphTextLabel])
        windMphView.axis = .vertical
        
        let view = UIStackView(arrangedSubviews: [uvView, visibilityView, windMphView, humidityView])
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .horizontal
        view.distribution = .fillEqually
        otherInfoView.addSubview(view)
        
        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: otherInfoView.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: otherInfoView.trailingAnchor),
            view.topAnchor.constraint(equalTo: otherInfoView.topAnchor),
            view.bottomAnchor.constraint(equalTo: otherInfoView.bottomAnchor)
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
            self.navigationItem.title = "\(weather.locationString)"
            self.temperatureLabel.text = weather.current.tempString
            self.feelsLikeLabel.text = weather.current.feelsLikeString
            self.conditionDescLabel.text = weather.current.condition
            self.dateLabel.text = weather.forecast.first?.days.formmattedDay
            self.uvIndexLabel.text = weather.current.uvIndexString
            
            let config = UIImage.SymbolConfiguration(pointSize: 48, weight: .light)
            self.conditionImageView.image = UIImage(systemName: getConditionName(weather.current.conditionCode, weather.current.is_day, withFill: true), withConfiguration: config)
            
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

// MARK: - UISearchResultsUpdating
extension WeatherViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let results = ["London", "Islikngton", "Hackney"]
        guard let text = searchController.searchBar.text else { return }
        if text.count > 2 {
            weatherManager.fetchSearches(input: text)
            if let resultsVC = searchController.searchResultsController as? SearchResultsController {
                resultsVC.results = results
                resultsVC.tableView.reloadData()
                print(resultsVC.results)
                
                // TODO: create no found label
    //            resultsController.resultsLabel.text = resultsController.filteredProducts.isEmpty ?
    //                NSLocalizedString("NoItemsFoundTitle", comment: "") :
    //                String(format: NSLocalizedString("Items found: %ld", comment: ""),
    //                       resultsController.filteredProducts.count)
            }
        }
    }
}

// MARK: - UISearchBarDelegate
extension WeatherViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // TODO: make it so when clicked it shows the results
        print("Search clicked")
    }
}
