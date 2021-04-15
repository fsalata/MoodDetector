//
//  DocumentSentiment.swift
//  MoodDetector
//
//  Created by Fabio Cezar Salata on 14/04/21.
//

import Foundation

struct SentimentPayload: Codable {
    let document: Document
    let encodingType: EncodingType
}

struct Document: Codable {
    let type: ContentType
    let content: String
}

enum ContentType: String, Codable {
    case unspecified = "TYPE_UNSPECIFIED"
    case plain = "PLAIN_TEXT"
    case html = "HTML"
}

enum EncodingType: String, Codable {
    case utf8 = "UTF8"
    case utf16 = "UTF16"
    case utf32 = "UTF32"
    case none = "NONE"
}
