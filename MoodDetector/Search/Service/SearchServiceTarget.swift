//
//  SearchServiceTarget.swift
//  MoodDetector
//
//  Created by Fabio Cezar Salata on 14/04/21.
//

import Foundation

enum SearchServiceTarget: ServiceTargetProtocol {
    case search(username: String)
}

extension SearchServiceTarget {
    var path: String {
        "/2/tweets/search/recent"
    }
    
    var method: RequestMethod {
        .GET
    }
    
    var header: [String : String]? {
        ["Authorization": "Bearer \(APIKeys.twitter.rawValue)"]
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

