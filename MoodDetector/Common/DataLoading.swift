//
//  DataLoading.swift
//  MoodDetector
//
//  Created by Fabio Cezar Salata on 15/04/21.
//

import UIKit

protocol DataLoading {
    var state: ViewState { get set }
    var loadingView: LoadingView { get }
    var feedbackView: FeedbackView { get }
    
    func update()
}

enum ViewState {
    case loading
    case loaded
    case error(_ error: APIError)
}

extension DataLoading where Self: UIViewController {
    func update() {
        switch state {
        case .loading:
            loadingView.show(in: self.view)
            feedbackView.remove(from: self.view)
            
        case .error(let error):
            loadingView.remove(from: self.view)
            feedbackView.show(in: self.view, with: error)
            
        case .loaded:
            loadingView.remove(from: self.view)
            feedbackView.remove(from: self.view)
        }
    }
}
