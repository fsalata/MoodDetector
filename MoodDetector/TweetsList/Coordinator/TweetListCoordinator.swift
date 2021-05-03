//
//  TweetListCoordinator.swift
//  MoodDetector
//
//  Created by Fabio Cezar Salata on 15/04/21.
//

import UIKit

class TweetListCoordinator: Coordinator {
    var navigationController: UINavigationController

    private(set) var viewModel: TweetListViewModel

    init(username: String, navigationController: UINavigationController) {
        self.navigationController = navigationController
        viewModel = TweetListViewModel(username: username)
    }

    func start() {
        let tweetListViewController = TweetListViewController(coordinator: self, viewModel: viewModel)
        navigationController.pushViewController(tweetListViewController, animated: true)
    }

    // MARK: - View methods
    func presentMoodResult(tweet: Tweet) {
        let moodResultCoordinator = MoodResultCoordinator(tweet: tweet, navigationController: navigationController)
        moodResultCoordinator.start()
    }
}
