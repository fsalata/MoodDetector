//
//  SearchViewController.swift
//  MoodDetector
//
//  Created by Fabio Cezar Salata on 14/04/21.
//

import UIKit

class SearchViewController: UIViewController {
    
    var coordinator: SearchCoordinator
    var viewModel: SearchViewModel
    
    init(coordinator: SearchCoordinator, viewModel: SearchViewModel) {
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

        view.backgroundColor = .green
    }

}
