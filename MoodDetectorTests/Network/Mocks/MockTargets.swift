//
//  MockTargets.swift
//  MoodDetectorTests
//
//  Created by Fabio Cezar Salata on 16/04/21.
//

import Foundation
@testable import MoodDetector

struct MockAPI: APIProtocol {
    let baseURL = "https://mock.com"
}

enum MockGETServiceTarget: ServiceTargetProtocol {
    case mock(page: Int)
}

extension MockGETServiceTarget {
    var path: String {
        "/mock/mocking"
    }

    var method: RequestMethod {
        .GET
    }

    var header: [String: String]? {
        [
            "Accept": "application/json",
            "Content-Type": "application/json"
        ]
    }

    var parameters: JSON? {
        var parameters: JSON = [:]
        switch self {
        case let .mock(page):
            parameters["page"] = "\(page)"
        }

        return parameters
    }

    var body: Data? {
        return nil
    }
}

enum MockPOSTServiceTarget: ServiceTargetProtocol {
    case mock(page: Int)
}

extension MockPOSTServiceTarget {
    var path: String {
        "/mock/mocking"
    }

    var method: RequestMethod {
        .POST
    }

    var header: [String: String]? {
        [
            "Accept": "application/json",
            "Content-Type": "application/json"
        ]
    }

    var parameters: JSON? {
        return nil
    }

    var body: Data? {
        return mockSentimentPayload()
    }
}
