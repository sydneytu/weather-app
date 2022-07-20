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
    
    func configureGradientLayer(){
        backgroundColor = .clear
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.systemPurple.cgColor, UIColor.systemPink.cgColor]
        gradient.locations = [0, 1]
        gradient.frame = bounds
        layer.addSublayer(gradient)
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

extension String {
    func attributedTempString (color: UIColor) -> NSMutableAttributedString {
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: color,
            .font: UIFont.boldSystemFont(ofSize: 16)
        ]
        let attributedString = NSMutableAttributedString(string: self, attributes: attributes)
        return attributedString
    }
}
