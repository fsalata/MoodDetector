//
//  Tweets.swift
//  MoodDetector
//
//  Created by Fabio Cezar Salata on 14/04/21.
//

import Foundation

struct SearchResult: Decodable {
    let data: [Tweet]
}

struct Tweet: Decodable {
    let id: String
    let text: String
}
