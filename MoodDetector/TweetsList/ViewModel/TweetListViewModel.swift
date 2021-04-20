//
//  TweetListViewModel.swift
//  MoodDetector
//
//  Created by Fabio Cezar Salata on 15/04/21.
//

import Foundation
import Combine

final class TweetListViewModel {
    private let service: TweetListService
    private var subscriptions = Set<AnyCancellable>()
    
    let username: String
    
    @Published private(set) var tweets: [Tweet]?
    @Published private(set) var error: APIError?
    
    var meta: Meta?
    
    // Init
    init(username: String, service: TweetListService = TweetListService()) {
        self.username = username
        self.service = service
    }
    
    // MARK: - Fetch user tweets
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
