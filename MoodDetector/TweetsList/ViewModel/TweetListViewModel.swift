//
//  TweetListViewModel.swift
//  MoodDetector
//
//  Created by Fabio Cezar Salata on 15/04/21.
//

import Foundation
import Combine

final class TweetListViewModel {
    let username: String
    let service: SearchService
    
    @Published var tweets: [Tweet] = []
    
    private var subscriptions = Set<AnyCancellable>()
    
    init(username: String, service: SearchService = SearchService()) {
        self.username = username
        self.service = service
    }
    
    func fetchUserTweets() {
        service.fetchUserRecentTweets(username: username)
            .sink { completion in
                print(completion)
            } receiveValue: { [weak self] result in
                guard let self = self else { return }
                
                guard result.data.count > 0 else {
                    return
                }
                
                self.tweets = result.data
            }
            .store(in: &subscriptions)
    }
}
