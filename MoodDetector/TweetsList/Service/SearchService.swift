//
//  SearchService.swift
//  MoodDetector
//
//  Created by Fabio Cezar Salata on 14/04/21.
//

import Foundation
import Combine

final class SearchService {
    var client = APIClient(api: TwitterAPI())
    
    func fetchUserRecentTweets(username: String) -> AnyPublisher<SearchResult, APIError> {
        return client.request(target: TweetListServiceTarget.search(username: username))
    }
}
