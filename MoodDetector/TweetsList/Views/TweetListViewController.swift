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

    // Inital properties
    private let coordinator: TweetListCoordinator
    private let viewModel: TweetListViewModel

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
    init(coordinator: TweetListCoordinator, viewModel: TweetListViewModel) {
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

        setupSubscriptions()

        fetchTweets()
    }

    // MARK: - Private methods
    private func setupView() {
        navigationItem.backButtonDisplayMode = .minimal

        title = "\(viewModel.username.capitalized) \(TweetListStrings.title)"

        tableView.registerCell(of: TweetsTableViewCell.self)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()

        feedbackView.delegate = self
    }

    private func setupSubscriptions() {
        viewModel.$tweets
            .sink {[weak self] _ in
                guard let self = self else { return }
                self.handleDataChanged()
            }
            .store(in: &subscriptions)

        viewModel.$error
            .compactMap { $0 }
            .sink {[weak self] error in
                guard let self = self else { return }
                self.showError(error)
            }
            .store(in: &subscriptions)
    }

    private func fetchTweets() {
        state = .loading
        viewModel.fetchUserTweets()
    }

    private func handleDataChanged() {
        DispatchQueue.main.async {
            guard let tweet = self.viewModel.tweets else {
                if self.viewModel.meta != nil {
                    self.showUserNotFoundFeedback()
                }

                return
            }

            guard tweet.count > 0 else {
                self.showUserNotFoundFeedback()
                return
            }

            self.tableView.reloadData()
            self.state = .loaded
        }
    }

    // MARK: - Error handling
    private func showUserNotFoundFeedback() {
        feedbackView.configure(message: TweetListStrings.NotFoundError.message,
                               buttonTitle: TweetListStrings.NotFoundError.buttonTitle)

        state = .error(nil)
    }

    private func showError(_ error: APIError?) {
        feedbackView.configure(message: TweetListStrings.ServiceError.message,
                               buttonTitle: TweetListStrings.ServiceError.buttonTitle)

        state = .error(error)
    }
}

// MARK: - UITableViewDataSource
extension TweetListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.tweets?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueCell(of: TweetsTableViewCell.self, for: indexPath) { [weak self] cell in
            guard let self = self else { return }

            if let tweet = self.viewModel.tweets?[indexPath.row] {
                cell.configure(tweet: tweet)
            }
        }
    }
}

// MARK: - UITableViewDelegate
extension TweetListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let tweet = viewModel.tweets?[indexPath.row] {
            coordinator.presentMoodResult(tweet: tweet)
        }
    }
}

// MARK: - FeedbackViewDelegate
extension TweetListViewController: FeedbackViewDelegate {
    func feedbackViewPerformAction(_ feedbackView: FeedbackView) {
        guard viewModel.error == nil else {
            fetchTweets()
            return
        }

        navigationController?.popViewController(animated: true)
    }
}
