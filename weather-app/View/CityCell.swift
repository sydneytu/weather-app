//
//  CityCell.swift
//  weather-app
//
//  Created by Sydney Turner on 12/26/22.
//

import Foundation
import UIKit

class CityCell: UITableViewCell {
    var city: SearchResultsModel? {
        didSet {
            cityRegionLabel.text = "\(city?.name ?? "city"), \(city?.region ?? "region")"
            countryLabel.text = city?.country
        }
    }
    
    private let cityRegionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.text = "New York, New York"
        return label
    }()
    
    private let countryLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = .lightGray
        label.text = "USA"
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let stack = UIStackView(arrangedSubviews: [cityRegionLabel, countryLabel])
        stack.axis = .vertical
        stack.spacing = 2
        stack.alignment = .leading
        addSubview(stack)
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            stack.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
        ])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
