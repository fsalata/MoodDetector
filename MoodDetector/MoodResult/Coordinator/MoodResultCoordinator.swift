//
//  MoodResultCoordintor.swift
//  MoodDetector
//
//  Created by Fabio Cezar Salata on 16/04/21.
//

import UIKit

class MoodResultCoordinator: Coordinator {
    var navigationController: UINavigationController

    private(set) var viewModel: MoodResultViewModel

    init(tweet: Tweet, navigationController: UINavigationController) {
        self.navigationController = navigationController
        viewModel = MoodResultViewModel(tweet: tweet)
    }

    func start() {
        let moodResultViewController = MoodResultViewController(coordinator: self, viewModel: viewModel)
        navigationController.pushViewController(moodResultViewController, animated: true)
    }
}
