//
//  Tweets.swift
//  MoodDetector
//
//  Created by Fabio Cezar Salata on 14/04/21.
//

import Foundation

struct SearchResult: Decodable {
    let data: [Tweet]?
    let meta: Meta?
}

struct Tweet: Decodable, Equatable {
    let id: String
    let text: String
}

struct Meta: Decodable {
    let resultCount: Float

    enum CodingKeys: String, CodingKey {
        case resultCount = "result_count"
    }
}
