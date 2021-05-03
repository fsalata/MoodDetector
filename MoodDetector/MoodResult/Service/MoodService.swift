//
//  MoodService.swift
//  MoodDetector
//
//  Created by Fabio Cezar Salata on 14/04/21.
//

import Foundation
import Combine

final class MoodService {
    private var client: APIClient

    init(client: APIClient = APIClient(api: GoogleAPI())) {
        self.client = client
    }

    func analyzeTweetMood(tweet: Tweet) -> AnyPublisher<SentimentResult, APIError> {
        let document = Document(type: .plain, content: tweet.text)
        let payload = SentimentPayload(document: document, encodingType: .utf8)

        return client.request(target: MoodServiceTarget.analyze(document: payload))
    }
}
