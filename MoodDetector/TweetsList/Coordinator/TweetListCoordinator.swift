//
//  TweetListCoordinator.swift
//  MoodDetector
//
//  Created by Fabio Cezar Salata on 15/04/21.
//

import UIKit

final class TweetListCoordinator: Coordinator {
    var navigationController: UINavigationController
    
    var tweetListViewModel: TweetListViewModel
    
    init(username: String, navigationController: UINavigationController) {
        self.navigationController = navigationController
        tweetListViewModel = TweetListViewModel(username: username)
    }
    
    func start() {
        let tweetListViewController = TweetListViewController(coordinator: self, viewModel: tweetListViewModel)
        navigationController.pushViewController(tweetListViewController, animated: true)
    }
}
