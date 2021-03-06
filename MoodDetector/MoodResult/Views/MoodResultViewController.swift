//
//  MoodResultViewController.swift
//  MoodDetector
//
//  Created by Fabio Cezar Salata on 16/04/21.
//

import UIKit
import Combine

class MoodResultViewController: UIViewController, DataLoading {
    @IBOutlet weak var emojiLabel: UILabel!
    
    // Initial properties
    private let coordinator: MoodResultCoordinator
    private let viewModel: MoodResultViewModel
    
    // Subscriptions
    private var subscriptions = Set<AnyCancellable>()
    
    // MARK: - Data Loading properties
    var state: ViewState = .loading {
        didSet {
            update()
        }
    }
    
    var loadingView = LoadingView()
    var feedbackView = FeedbackView()
    
    // MARK: - Init
    init(coordinator: MoodResultCoordinator, viewModel: MoodResultViewModel) {
        self.coordinator = coordinator
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
        fetchAnalysis()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        if (isBeingDismissed || isMovingFromParent) {
            subscriptions.removeAll()
        }
    }
    
    // MARK: - Private methodss
    private func setupView() {
        title = MoodResultStrings.title
        
        feedbackView.delegate = self
        
        viewModel.$sentiment
            .sink(receiveValue: { [weak self] result in
                guard let self = self else { return }
                
                self.updateMood(result)
            })
            .store(in: &subscriptions)
        
        viewModel.$error
            .sink { [weak self] error in
                guard let self = self,
                      error != nil else { return }
                self.showError(error)
            }
            .store(in: &subscriptions)
    }
    
    private func fetchAnalysis() {
        state = .loading
        
        viewModel.fetchAnalysis()
    }
    
    private func updateMood(_ emoji: String?) {
        DispatchQueue.main.async {
            guard emoji != nil else { return }
            
            self.emojiLabel.text = emoji
            self.state = .loaded
            
            UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.45,
                                                           delay: 0,
                                                           options: .curveEaseInOut) {
                self.emojiLabel.alpha = 1
            }

        }
    }
    
    // MARK: - Error handling
    private func showError(_ error: APIError?) {
        feedbackView.configure(message: MoodResultStrings.ServiceError.message,
                               buttonTitle: MoodResultStrings.ServiceError.buttonTitle)
        
        state = .error(error)
    }
}

// MARK: - FeedbackViewDelegate
extension MoodResultViewController: FeedbackViewDelegate {
    func feedbackViewPerformAction(_ feedbackView: FeedbackView) {
        fetchAnalysis()
    }
}
