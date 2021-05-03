//
//  MoodResultViewModel.swift
//  MoodDetector
//
//  Created by Fabio Cezar Salata on 16/04/21.
//

import Foundation
import Combine

final class MoodResultViewModel: ObservableObject {
    private var service: MoodService
    private var subscriptions = Set<AnyCancellable>()
    
    private(set) var tweet: Tweet
    
    @Published private(set) var sentiment: String?
    @Published private(set) var error: APIError?
    
    // Init
    init(tweet: Tweet, service: MoodService = MoodService()) {
        self.service = service
        self.tweet = tweet
    }
    
    // MARK: - Fetch analysis
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
    
    // Private methods
    private func analyzeMoodResult(_ documentSentiment: DocumentSentiment) {
        switch documentSentiment.score {
        case 0.25...1:
            sentiment = MoodEmoji.happy.rawValue
        case -1.0...(-0.25):
            sentiment = MoodEmoji.sad.rawValue
        default:
            sentiment = MoodEmoji.neutral.rawValue
        }
    }
}
