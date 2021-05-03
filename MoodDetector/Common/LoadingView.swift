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
    }()

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)

        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        commonInit()
    }

    private func commonInit() {
        setupLayout()
        setupView()
    }

    // MARK: - Private methods
    private func setupLayout() {
        self.addSubview(activityIndicator)

        activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }

    private func setupView() {
        self.backgroundColor = .white
        self.translatesAutoresizingMaskIntoConstraints = false
    }

    /// Show loading
    /// - Parameter view: view where loading will be added
    func show(in view: UIView) {
        DispatchQueue.main.async {
            view.addSubview(self)

            self.pinEdgesToSuperview()
            self.activityIndicator.startAnimating()
        }
    }

    /// Remove loading
    /// - Parameter view: view where loading will be removed from
    func remove(from view: UIView) {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.removeFromSuperview()
        }
    }
}
