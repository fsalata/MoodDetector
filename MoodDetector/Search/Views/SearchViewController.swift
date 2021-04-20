//
//  SearchViewController.swift
//  MoodDetector
//
//  Created by Fabio Cezar Salata on 14/04/21.
//

import UIKit
import Combine

class SearchViewController: UIViewController {
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var searchInfoLabel: UILabel!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var searchButton: RoundButton!
    @IBOutlet weak var errorMessageLabel: UILabel!
    
    // Initial properties
    private let coordinator: SearchCoordinator
    
    // MARK: - Init
    init(coordinator: SearchCoordinator) {
        self.coordinator = coordinator
        
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        animateViews()
    }

    // MARK: - Private methods
    private func setupView() {
        navigationItem.backButtonDisplayMode = .minimal
        
        title = "Mood Detector"
        
        prepareViewsForAnimation()
        
        usernameTextField.delegate = self
    }
    
    // MARK: - Animation
    private func prepareViewsForAnimation() {
        if let navigationBarHeight = navigationController?.navigationBar.frame.height {
            usernameTextField.alpha = 0
            searchButton.alpha = 0
            searchInfoLabel.alpha = 0
            
            let yPos = view.center.y - logoImageView.center.y - navigationBarHeight - 20
            logoImageView.transform = CGAffineTransform(translationX: 0, y: yPos)
        }
    }
    
    private func animateViews() {
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.45, delay: 0, options: .curveEaseInOut) {
            self.logoImageView.transform = .identity
        }
        
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.45, delay: 0.15, options: .curveEaseInOut) {
            self.usernameTextField.alpha = 1
            self.searchButton.alpha = 1
            self.searchInfoLabel.alpha = 1
        }
    }
    
    // MARK: - Actions
    @IBAction func search(_ sender: Any) {
        guard let username = usernameTextField.text,
              !username.isEmpty else {
            errorMessageLabel.isHidden = false
            return
        }
        
        if let username = usernameTextField.text,
           !username.isEmpty {
            usernameTextField.resignFirstResponder()
            coordinator.presentTweetResult(for: username)
        }
    }
}

// MARK: - UITextFieldDelegate
extension SearchViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        errorMessageLabel.isHidden = true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let text = textField.text,
           !text.isEmpty {
            search(textField)
        }
        
        textField.resignFirstResponder()
        return true
    }
}
