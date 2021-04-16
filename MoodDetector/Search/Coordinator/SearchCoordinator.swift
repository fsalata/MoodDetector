//
//  SearchCoordinator.swift
//  MoodDetector
//
//  Created by Fabio Cezar Salata on 14/04/21.
//

import UIKit

final class SearchCoordinator: Coordinator {
    var navigationController: UINavigationController
    
    var tweetListCoordinator: TweetListCoordinator!
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewModel = SearchViewModel()
        let searchViewController = SearchViewController(coordinator: self, viewModel: viewModel)
        navigationController.pushViewController(searchViewController, animated: false)
    }
}

extension SearchCoordinator {
    func presentTweetResult(for username: String) {
        tweetListCoordinator = TweetListCoordinator(username: username, navigationController: navigationController)
        tweetListCoordinator.start()
    }
}
