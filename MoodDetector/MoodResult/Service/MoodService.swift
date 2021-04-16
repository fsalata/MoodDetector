//
//  MoodService.swift
//  MoodDetector
//
//  Created by Fabio Cezar Salata on 14/04/21.
//

import Foundation
import Combine

final class MoodService {
    let client = APIClient(api: GoogleAPI())
    
    func analyzeTweetMood(tweet: Tweet) -> AnyPublisher<SentimentResult, APIError> {
        let document = Document(type: .plain, content: tweet.text)
        let payload = SentimentPayload(document: document, encodingType: .utf8)
        
        return client.request(target: MoodServiceTarget.analyze(document: payload))
    }
}
