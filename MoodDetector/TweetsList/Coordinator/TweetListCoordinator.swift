//
//  TweetListCoordinator.swift
//  MoodDetector
//
//  Created by Fabio Cezar Salata on 15/04/21.
//

import UIKit

final class TweetListCoordinator: Coordinator {
    var navigationController: UINavigationController
    
    var viewModel: TweetListViewModel
    
    var moodResultCoordinator: MoodResultCoordinator!
    
    init(username: String, navigationController: UINavigationController) {
        self.navigationController = navigationController
        viewModel = TweetListViewModel(username: username)
    }
    
    func start() {
        let tweetListViewController = TweetListViewController(coordinator: self, viewModel: viewModel)
        navigationController.pushViewController(tweetListViewController, animated: true)
    }
}

extension TweetListCoordinator {
    func presentMoodResult(tweet: Tweet) {
        moodResultCoordinator = MoodResultCoordinator(tweet: tweet, navigationController: navigationController)
        moodResultCoordinator.start()
    }
}
