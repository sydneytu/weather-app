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
    
    
    // MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = UIColor.black.withAlphaComponent(0)
        
        
//        NSLayoutConstraint.activate([
//            self.leadingAnchor.constraint(equalTo: self.leadingAnchor),
//            self.trailingAnchor.constraint(equalTo: self.trailingAnchor),
//            self.topAnchor.constraint(equalTo: self.topAnchor),
//            self.bottomAnchor.constraint(equalTo: self.bottomAnchor)
//        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
