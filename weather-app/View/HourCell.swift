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
        label.text = "10 AM"
        label.font = UIFont.systemFont(ofSize: 18, weight: .light)
        label.sizeToFit()
        label.textColor = .white
        return label
    }()
    
    private var tempLabel: UILabel = {
        let label = UILabel()
        label.text = "75°"
        label.font = UIFont.systemFont(ofSize: 18, weight: .light)
        label.sizeToFit()
        label.textColor = .white
        return label
    }()
    
    // image
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = #colorLiteral(red: 0.752800405, green: 0.7788824439, blue: 0.9847370982, alpha: 0.2809135993)
        
        layer.cornerRadius = 25
        
        let stackView = UIStackView(arrangedSubviews: [timeLabel, tempLabel])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        
        addSubview(stackView)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    
    // MARK: - Helpers

}
