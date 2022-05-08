//
//  ViewController.swift
//  weather-app
//
//  Created by Sydney Turner on 5/7/22.
//

import UIKit

class ViewController: UIViewController {
    
    
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
        cityLabel.text = "Los Angeles"
        cityLabel.font = UIFont.systemFont(ofSize: 25, weight: .regular)
//        cityLabel.backgroundColor = .green
        cityLabel.sizeToFit()
        return cityLabel
    }()
    
    private let temperatureLabel: UILabel = {
        let temperatureLabel = UILabel()
        temperatureLabel.text = "78°F"
        temperatureLabel.font = UIFont.systemFont(ofSize: 72, weight: .semibold)
//        temperatureLabel.backgroundColor = .link
        temperatureLabel.sizeToFit()
        return temperatureLabel
    }()
    
    private let dateLabel: UILabel = {
       let dateLabel = UILabel()
        dateLabel.text = "May 8"
        dateLabel.font = UIFont.systemFont(ofSize: 18, weight: .light)
//        dateLabel.backgroundColor = .cyan
        dateLabel.sizeToFit()
        return dateLabel
    }()
    
    private let currentLocationButton: UIButton = {
       let currentLocationButton = UIButton()
        currentLocationButton.setImage(UIImage(systemName: "location"), for: .normal)
        currentLocationButton.sizeToFit()
        currentLocationButton.tintColor = .white
        return currentLocationButton
    }()
    
    private let searchButton: UIButton = {
       let searchButton = UIButton()
        searchButton.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        searchButton.sizeToFit()
        searchButton.tintColor = .white
        return searchButton
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = #colorLiteral(red: 0.2705882353, green: 0.3215686275, blue: 0.768627451, alpha: 1)
        createMainView()
        cityLabel.text = "Paris, France"
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
        let currentWeatherStackView = UIStackView(arrangedSubviews: [temperatureLabel, dateLabel])
        currentWeatherStackView.translatesAutoresizingMaskIntoConstraints = false
        currentWeatherStackView.axis = .vertical
//        currentWeatherStackView.backgroundColor = .blue
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
            currentWeatherStackView.topAnchor.constraint(equalTo: currentWeatherView.topAnchor, constant: 20),
            currentWeatherStackView.bottomAnchor.constraint(equalTo: currentWeatherView.bottomAnchor, constant: -20)
            
        ])
    }
    
}

