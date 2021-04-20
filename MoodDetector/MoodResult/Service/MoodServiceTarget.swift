//
//  MoodServiceTarget.swift
//  MoodDetector
//
//  Created by Fabio Cezar Salata on 14/04/21.
//

import Foundation

enum MoodServiceTarget: ServiceTargetProtocol{
    case analyze(document: SentimentPayload)
}

extension MoodServiceTarget {
    var path: String {
        "/v1beta2/documents:analyzeSentiment"
    }
    
    var method: RequestMethod {
        .POST
    }
    
    var header: [String : String]? {
        return ["Content-Type": "application/json"]
    }
    
    var parameters: JSON? {
        var parameters: [String : String] = [:]
        switch self {
        case .analyze:
            parameters["key"] = "\(APIKeys.google)"
        }
        
        return parameters
    }
    
    var body: Data? {
        switch self {
        case .analyze(let document):
            return try? JSONEncoder().encode(document)
        }
    }
}


