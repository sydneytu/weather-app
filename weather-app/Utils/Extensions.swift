//
//  Extensions.swift
//  weather-app
//
//  Created by Sydney Turner on 7/16/22.
//

import Foundation
import UIKit

extension UIView {
    func configureUIView() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.layer.cornerRadius = 25
    }
}

extension UILabel {
    func configureLabel(size: CGFloat, weight: UIFont.Weight, text: String) {
        self.text = text
        self.font = UIFont.systemFont(ofSize: size, weight: weight)
        self.sizeToFit()
        self.textColor = .white
    }
}
