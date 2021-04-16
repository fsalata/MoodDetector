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
    
    private var coordinator: MoodResultCoordinator
    private var viewModel: MoodResultViewModel
    
    // MARK: - Data Loading properties
    var state: ViewState = .loading {
        didSet {
            update()
        }
    }
    
    var loadingView = LoadingView()
    var feedbackView = FeedbackView()
    
    var subscriptions = Set<AnyCancellable>()
    
    init(coordinator: MoodResultCoordinator, viewModel: MoodResultViewModel) {
        self.coordinator = coordinator
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
        fetchAnalysis()
    }
    
    private func setupView() {
        title = "Resultado"
        
        feedbackView.delegate = self
        
        viewModel.$sentiment
            .sink(receiveValue: { [weak self] result in
                guard let self = self else { return }
                
                self.updateMood(result)
            })
            .store(in: &subscriptions)
        
        viewModel.$error
            .sink { error in
                guard error != nil else { return }
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
        }
    }
    
    private func showError(_ error: APIError?) {
        feedbackView.configure(message: "Ocorreu um erro com a sua solicitação",
                               buttonTitle: "Tentar novamente?")
        
        state = .error(error)
    }
}

extension MoodResultViewController: FeedbackViewDelegate {
    func feedbackViewPerformAction(_ feedbackView: FeedbackView) {
        fetchAnalysis()
    }
}
