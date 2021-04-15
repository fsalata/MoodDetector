//
//  TweetListViewController.swift
//  MoodDetector
//
//  Created by Fabio Cezar Salata on 15/04/21.
//

import UIKit
import Combine

class TweetListViewController: UIViewController, DataLoading {
    @IBOutlet weak var tableView: UITableView!
    
    let coordinator: TweetListCoordinator
    let viewModel: TweetListViewModel
    
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
    init(coordinator: TweetListCoordinator, viewModel: TweetListViewModel) {
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
        
        fetchTweets()
    }
    
    private func setupView() {
        navigationItem.backButtonDisplayMode = .minimal
        
        tableView.registerCell(of: TweetsTableViewCell.self)
        tableView.dataSource = self
        tableView.delegate = self
        
        feedbackView.setButtonAction {
            self.fetchTweets()
        }
        
        viewModel.$tweets
            .sink { tweets in
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.state = .loaded
                }
            }
            .store(in: &subscriptions)
    }
    
    private func fetchTweets() {
        state = .loading
        viewModel.fetchUserTweets()
    }
}

extension TweetListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.tweets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueCell(of: TweetsTableViewCell.self, for: indexPath) { [weak self] cell in
            guard let self = self else { return }
            
            cell.configure(tweet: self.viewModel.tweets[indexPath.row])
        }
    }
}

extension TweetListViewController: UITableViewDelegate {
    
}
