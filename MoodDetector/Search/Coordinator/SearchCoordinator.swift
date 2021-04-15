//
//  SearchCoordinator.swift
//  MoodDetector
//
//  Created by Fabio Cezar Salata on 14/04/21.
//

import UIKit

final class SearchCoordinator: Coordinator {
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewModel = SearchViewModel()
        let searchViewController = SearchViewController(coordinator: self, viewModel: viewModel)
        navigationController.pushViewController(searchViewController, animated: false)
    }
}
