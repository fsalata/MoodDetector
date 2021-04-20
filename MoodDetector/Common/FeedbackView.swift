//
//  FeedbackView.swift
//  MoodDetector
//
//  Created by Fabio Cezar Salata on 15/04/21.
//

import UIKit

protocol FeedbackViewDelegate: AnyObject {
    func feedbackViewPerformAction(_ feedbackView: FeedbackView)
}

final class FeedbackView: UIView  {
    lazy private(set) var emojiLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue", size: 120.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy private(set) var messageLabel: UILabel! = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue", size: 14.0)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy private(set) var button: RoundButton = {
        let button = RoundButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .systemBlue
        return button
    }()
    
    weak var delegate: FeedbackViewDelegate?
    
    // Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
        
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK - Private methods
    private func setupLayout() {
        let containerView = UIStackView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.axis = .vertical
        containerView.spacing = 16
        containerView.alignment = .center
        
        self.addSubview(containerView)
        
        containerView.addArrangedSubviews(emojiLabel, messageLabel, button)
        
        NSLayoutConstraint.activate([
            containerView.leftAnchor.constraint(equalTo: leftAnchor, constant: 16),
            containerView.rightAnchor.constraint(equalTo: rightAnchor, constant: -16),
            containerView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
        
    }
    
    private func setupView() {
        self.backgroundColor = .white
        self.translatesAutoresizingMaskIntoConstraints = false
        self.button.addTarget(self, action: #selector(self.handleButtonTap(sender:)), for: .touchUpInside)
    }
    
    /// Configure view labels
    /// - Parameters:
    ///   - message: feedback message
    ///   - buttonTitle: button title
    ///   - emoji: emoji to be shown (String)
    func configure(message: String,
                   buttonTitle: String,
                   emoji: String = MoodEmoji.sad.rawValue) {
        DispatchQueue.main.async {
            self.messageLabel.text = message
            self.emojiLabel.text = emoji
            self.button.setTitle(buttonTitle, for: .normal)
        }
    }
    
    /// Show feedback
    /// - Parameters:
    ///   - view: view where feedback will be added
    ///   - error: APIError
    func show(in view: UIView, with error: APIError?) {
        view.addSubview(self)
        
        self.pinEdgesToSuperview()
    }
    
    /// Remove feedback
    /// - Parameter view: view where feedback will be removed from
    func remove(from view: UIView) {
        removeFromSuperview()
    }
    
    // MARK: - Actions
    @objc private func handleButtonTap(sender: UIButton) {
        if delegate != nil {
            delegate?.feedbackViewPerformAction(self)
        }
        
        removeFromSuperview()
    }
}
