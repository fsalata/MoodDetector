//
//  LoadingView.swift
//  MoodDetector
//
//  Created by Fabio Cezar Salata on 15/04/21.
//

import UIKit

final class LoadingView: UIView {
    lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    } ()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
        
        setupView()
    }
    
    // MARK - Private methods
    private func setupLayout() {
        self.addSubview(activityIndicator)
        
        activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
    
    private func setupView() {
        self.backgroundColor = .white
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func show(in view: UIView) {
        view.addSubview(self)
        
        self.pinEdgesToSuperview()
        activityIndicator.startAnimating()
    }
    
    func remove(from view: UIView) {
        activityIndicator.stopAnimating()
        removeFromSuperview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
