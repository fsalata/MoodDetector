//
//  UIView+Constraints.swift
//  MoodDetector
//
//  Created by Fabio Cezar Salata on 15/04/21.
//

import Foundation
import UIKit

extension UIView {
    
    /// Helper to add constraints to a view
    /// - Parameters:
    ///   - top: top anchor.
    ///   - left: left anchor.
    ///   - bottom: bottom anchor.
    ///   - right: right anchor.
    ///   - padding: padding (UIEdgeInsets). Default 0.
    ///   - size: size (CGCize). Default 0.
    func anchor(top: NSLayoutYAxisAnchor?, left: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, right: NSLayoutXAxisAnchor?, padding: UIEdgeInsets = .zero, size: CGSize = .zero) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: padding.top).isActive = true
        }
        
        if let left = left {
            leftAnchor.constraint(equalTo: left, constant: padding.left).isActive = true
        }
        
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: padding.bottom).isActive = true
        }
        
        if let right = right {
            rightAnchor.constraint(equalTo: right, constant: padding.right).isActive = true
        }
        
        if size.width != 0 {
            widthAnchor.constraint(equalToConstant: size.width).isActive = true
        }
        
        if size.height != 0 {
            heightAnchor.constraint(equalToConstant: size.height).isActive = true
        }
    }
    
    
    /// Pin view do superview
    /// - Parameter offset: margin
    func pinEdgesToSuperview(_ offset: CGFloat = 0.0) {
        guard let superview = self.superview else {
            return
        }
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.leftAnchor.constraint(equalTo: superview.leftAnchor, constant: offset).isActive = true
        self.rightAnchor.constraint(equalTo: superview.rightAnchor, constant: offset).isActive = true
        self.bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: offset).isActive = true
        self.topAnchor.constraint(equalTo: superview.topAnchor, constant: offset).isActive = true
    }
    
    
    /// Add multiple subviews
    /// - Parameter subviews: subviews to be added.
    func addSubviews(_ subviews: UIView...) {
        subviews.forEach(addSubview)
    }
}
