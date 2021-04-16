//
//  UIStackView+Extensions.swift
//  MoodDetector
//
//  Created by Fabio Cezar Salata on 16/04/21.
//

import UIKit

extension UIStackView {
    func addArrangedSubviews(_ subviews: UIView...) {
        subviews.forEach(addArrangedSubview)
    }
}
