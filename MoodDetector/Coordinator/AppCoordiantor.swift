//
//  AppCoordiantor.swift
//  MoodDetector
//
//  Created by Fabio Cezar Salata on 14/04/21.
//

import UIKit

class AppCoordinator: Coordinator {
    var navigationController: UINavigationController

    private var searchCoordinator: SearchCoordinator?

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let searchCoordinator = SearchCoordinator(navigationController: navigationController)

        searchCoordinator.start()

        self.searchCoordinator = searchCoordinator
    }
}
