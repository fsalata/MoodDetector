//
//  SearchServiceTarget.swift
//  MoodDetector
//
//  Created by Fabio Cezar Salata on 14/04/21.
//

import Foundation

enum TweetListServiceTarget: ServiceTargetProtocol {
    case search(username: String)
}

extension TweetListServiceTarget {
    var path: String {
        "/2/tweets/search/recent"
    }
    
    var method: RequestMethod {
        .GET
    }
    
    var header: [String : String]? {
        ["Authorization": "Bearer \(APIKeys.twitter)"]
    }
    
    var parameters: JSON? {
        var parameters: [String : String] = [:]
        switch self {
        case let .search(username):
            parameters["query"] = "from:\(username)"
        }
        
        return parameters
    }
    
    var body: Data? {
        return nil
    }
}

