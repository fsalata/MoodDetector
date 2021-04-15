//
//  FeedbackView.swift
//  MoodDetector
//
//  Created by Fabio Cezar Salata on 15/04/21.
//

import UIKit

final class FeedbackView: UIView  {
    lazy var emojiLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue", size: 104.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var message: UILabel! = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue", size: 14.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var button: RoundButton = {
        let button = RoundButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .systemBlue
        return button
    }()
    
    private var buttonAction: (() -> Void)?
    
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
//
//        containerView.pinEdgesToSuperview()
        
//        addSubviews(emojiLabel, message, button)
        
        containerView.addArrangedSubview(emojiLabel)
        containerView.addArrangedSubview(message)
        containerView.addArrangedSubview(button)
        
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            button.widthAnchor.constraint(equalToConstant: 150)
            
        ])
        
//        message.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: nil, right: containerView.rightAnchor)
//        button.anchor(top: layoutMarginsGuide.bottomAnchor, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, right: containerView.rightAnchor, padding: .init(top: 0, left: 0, bottom: -20, right: 0 ))
        
    }
    
    private func setupView() {
        self.backgroundColor = .white
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setButtonAction(_ buttonAction: (() -> Void)?) {
        self.buttonAction = buttonAction
    }
    
    func show(in view: UIView, with error: APIError) {
        view.addSubview(self)
        
        self.pinEdgesToSuperview()
        
        emojiLabel.text = MoodEmoji.frustrated.rawValue
        message.text = "Aconteceu um erro"
        button.setTitle("Tentar novamente", for: .normal)
        
        button.addTarget(self, action: #selector(handleButtonTap(sender:)), for: .touchUpInside)
    }
    
    func remove(from view: UIView) {
        removeFromSuperview()
    }
    
    @objc private func handleButtonTap(sender: UIButton) {
        buttonAction?()
        removeFromSuperview()
    }
}
