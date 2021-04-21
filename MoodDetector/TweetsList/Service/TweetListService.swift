//
//  TweetListService.swift
//  MoodDetector
//
//  Created by Fabio Cezar Salata on 14/04/21.
//

import Foundation
import Combine

final class TweetListService {
    private let client: APIClient
    
    init(client: APIClient = APIClient(api: TwitterAPI())) {
        self.client = client
    }
    
    func fetchUserRecentTweets(username: String) -> AnyPublisher<SearchResult, APIError> {
        return client.request(target: TweetListServiceTarget.search(username: username))
    }
}
