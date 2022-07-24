//
//  HourCell.swift
//  weather-app
//
//  Created by Sydney Turner on 5/19/22.
//

import Foundation
import UIKit

class HourCell: UICollectionViewCell {
    // MARK: - Properties
    
    private var timeLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 18, weight: .light)
        label.sizeToFit()
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()
    
    private var tempLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 25, weight: .regular)
        label.sizeToFit()
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()
    
    private let conditionImageView: UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.sizeToFit()
        iv.contentMode = .scaleAspectFit
        iv.tintColor = #colorLiteral(red: 0.4643017054, green: 0.4716814756, blue: 0.4766219258, alpha: 1)
        return iv
    }()
    
    var time: String? {
        didSet {
            timeLabel.text = "\(time!)"
        }
    }
    
    var temp: String? {
        didSet {
            tempLabel.text = "\(temp!)"
        }
    }
    
    var isCurrentCell: Bool? {
        didSet {
            if (isCurrentCell == true) {
                backgroundColor = #colorLiteral(red: 0.3450263739, green: 0.4461564422, blue: 0.9987166524, alpha: 1)
                tempLabel.textColor = .white
                timeLabel.textColor = .white
                conditionImageView.tintColor = .white
                conditionName?.append(".fill")
            }
        }
    }
    
    var conditionName: String? {
        didSet {
            if let conditionName = conditionName {
                let config = UIImage.SymbolConfiguration(pointSize: 32, weight: .light)
                self.conditionImageView.image = UIImage(systemName: conditionName, withConfiguration: config)
            }
        }
    }
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = #colorLiteral(red: 1, green: 0.9999999404, blue: 1, alpha: 1)
        layer.cornerRadius = 25
        
        let stackView = UIStackView(arrangedSubviews: [timeLabel, conditionImageView ,tempLabel])
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 5
        stackView.distribution = .fillEqually
        stackView.layer.cornerRadius = 25
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: self.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        backgroundColor = #colorLiteral(red: 1, green: 0.9999999404, blue: 1, alpha: 1)
        tempLabel.textColor = .black
        timeLabel.textColor = .black
        conditionImageView.tintColor = #colorLiteral(red: 0.4643017054, green: 0.4716814756, blue: 0.4766219258, alpha: 1)
    }
    
    // MARK: - Actions
    
    // MARK: - Helpers

}
