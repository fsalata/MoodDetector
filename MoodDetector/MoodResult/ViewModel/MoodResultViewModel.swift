//
//  MoodResultViewModel.swift
//  MoodDetector
//
//  Created by Fabio Cezar Salata on 16/04/21.
//

import Foundation
import Combine

final class MoodResultViewModel {
    var service: MoodService
    
    var tweet: Tweet
    
    @Published var sentiment: String?
    @Published var error: APIError?
    
    
    
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
        var sentimentEmoji = ""
        
        switch documentSentiment.score {
        case 0.25...1:
            sentimentEmoji = MoodEmoji.happy.rawValue
        case -1.0...(-0.25):
            sentimentEmoji = MoodEmoji.frustrated.rawValue
        default:
            sentimentEmoji = MoodEmoji.neutral.rawValue
        }
        
        sentiment = sentimentEmoji
    }
}
