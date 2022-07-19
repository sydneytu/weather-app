//
//  DailyCell.swift
//  weather-app
//
//  Created by Sydney Turner on 7/9/22.
//

import Foundation
import UIKit

class DailyCell: UITableViewCell {
    // MARK: - Properties
    private var dayLabel: UILabel = {
        let label = UILabel()
        label.text = "Sunday"
        label.font = UIFont.systemFont(ofSize: 18, weight: .light)
        label.sizeToFit()
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()
    
    private var tempLabel: UILabel = {
        let label = UILabel()
        label.text = "78° 62°"
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.sizeToFit()
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()
    
    private let conditionImageView: UIImageView = {
        let iv = UIImageView()
        let config = UIImage.SymbolConfiguration(pointSize: 36, weight: .light)
        iv.image = UIImage(systemName: "cloud.sun.rain", withConfiguration: config)
        iv.clipsToBounds = true
        iv.sizeToFit()
        iv.contentMode = .scaleAspectFit
        iv.tintColor = #colorLiteral(red: 0.4643017054, green: 0.4716814756, blue: 0.4766219258, alpha: 1)
        return iv
    }()
    
    private let conditionDescLabel: UILabel = {
        let label = UILabel()
        label.configureLabel(size: 18, weight: .light, text: "Partly Cloudy")
        label.textColor = .darkGray
        return label
    }()
    
    var day: String?
    var maxTemp: String?
    var minTemp: String?
    var conditionDesc: String?
    
    // MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = UIColor.black.withAlphaComponent(0)
        
        let stackView = UIStackView(arrangedSubviews: [dayLabel, tempLabel, conditionImageView])
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .equalSpacing
        
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            stackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
