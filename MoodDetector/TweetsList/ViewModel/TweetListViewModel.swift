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
    let service: TweetListService
    
    @Published var tweets: [Tweet]?
    @Published var error: APIError?
    
    var meta: Meta?
    
    private var subscriptions = Set<AnyCancellable>()
    
    init(username: String, service: TweetListService = TweetListService()) {
        self.username = username
        self.service = service
    }
    
    func fetchUserTweets() {
        service.fetchUserRecentTweets(username: username)
            .sink { [weak self] completion in
                guard let self = self else { return }
                
                if case .failure(let error) = completion {
                    self.error = error
                }
            } receiveValue: { [weak self] result in
                guard let self = self else { return }
                
                self.meta = result.meta
                self.tweets = result.data
            }
            .store(in: &subscriptions)
    }
}
