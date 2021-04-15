//
//  RoundButton.swift
//  MoodDetector
//
//  Created by Fabio Cezar Salata on 15/04/21.
//

import UIKit

@IBDesignable
class RoundButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        commonInit()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        
        commonInit()
    }
    
    private func commonInit() {
        layer.cornerRadius = 20
    }
}
