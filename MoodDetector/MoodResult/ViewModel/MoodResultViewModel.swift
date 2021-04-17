//
//  MoodResultViewModel.swift
//  MoodDetector
//
//  Created by Fabio Cezar Salata on 16/04/21.
//

import Foundation
import Combine

final class MoodResultViewModel {
    private var service: MoodService
    
    private(set) var tweet: Tweet
    
    @Published private(set) var sentiment: String?
    @Published private(set) var error: APIError?
    
    private var subscriptions = Set<AnyCancellable>()
    
    init(tweet: Tweet, service: MoodService = MoodService()) {
        self.service = service
        self.tweet = tweet
    }
    
    func fetchAnalysis() {
        service.analyzeTweetMood(tweet: tweet)
            .sink { [weak self] completion in
                guard let self = self else { return }
                
                if case .failure(let error) = completion {
                    self.error = error
                }
            } receiveValue: { [weak self] result in
                guard let self = self else { return }
                
                self.analyzeMoodResult(result.documentSentiment)
            }
            .store(in: &subscriptions)
    }
    
    private func analyzeMoodResult(_ documentSentiment: DocumentSentiment) {
        switch documentSentiment.score {
        case 0.25...1:
            sentiment = MoodEmoji.happy.rawValue
        case -1.0...(-0.25):
            sentiment = MoodEmoji.frustrated.rawValue
        default:
            sentiment = MoodEmoji.neutral.rawValue
        }
    }
}
