//
//  SearchCoordinator.swift
//  MoodDetector
//
//  Created by Fabio Cezar Salata on 14/04/21.
//

import UIKit

class SearchCoordinator: Coordinator {
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let searchViewController = SearchViewController(coordinator: self)
        navigationController.pushViewController(searchViewController, animated: false)
    }
    
    // MARK: - View methods
    func presentTweetResult(for username: String) {
        let tweetListCoordinator = TweetListCoordinator(username: username, navigationController: navigationController)
        tweetListCoordinator.start()
    }
}
