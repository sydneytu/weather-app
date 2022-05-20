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
        label.textColor = .white
        return label
    }()
    
    private var tempLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.boldSystemFont(ofSize: 25)
        label.sizeToFit()
        label.textAlignment = .center
        label.textColor = .white
        return label
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
    
    // image
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = #colorLiteral(red: 0.752800405, green: 0.7788824439, blue: 0.9847370982, alpha: 0.2809135993)
        
        layer.cornerRadius = 25
        
        let stackView = UIStackView(arrangedSubviews: [timeLabel, tempLabel])
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
        
        if let time = time {
//            time = 
        }
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    
    // MARK: - Helpers

}
