//
//  Mood.swift
//  MoodDetector
//
//  Created by Fabio Cezar Salata on 14/04/21.
//

import Foundation

struct SentimentResult: Decodable {
    let documentSentiment: DocumentSentiment
}

struct DocumentSentiment: Decodable {
    let magnitude: Double
    let score: Double
}
