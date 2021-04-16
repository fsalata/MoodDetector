//
//  SearchViewController.swift
//  MoodDetector
//
//  Created by Fabio Cezar Salata on 14/04/21.
//

import UIKit
import Combine

class SearchViewController: UIViewController {
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var searchButton: RoundButton!
    @IBOutlet weak var errorMessageLabel: UILabel!
    
    // Initial properties
    var coordinator: SearchCoordinator
    var viewModel: SearchViewModel
    
    // Subscriptions
    var subscriptions = Set<AnyCancellable>()
    
    // MARK: - Init
    init(coordinator: SearchCoordinator, viewModel: SearchViewModel) {
        self.coordinator = coordinator
        self.viewModel = viewModel
        
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

    // MARK: - Private methods
    private func setupView() {
        navigationItem.backButtonDisplayMode = .minimal
        
        title = "Mood Detector"
        
        usernameTextField.delegate = self
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
            coordinator.presentTweetResult(for: username)
        }
    }
}

// MARK: - UITextFieldDelegate
extension SearchViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        errorMessageLabel.isHidden = true
    }
}
