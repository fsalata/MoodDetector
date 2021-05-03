//
//  URLSessionSpy.swift
//  MoodDetectorTests
//
//  Created by Fabio Cezar Salata on 16/04/21.
//

import Foundation
import Combine
@testable import MoodDetector

class URLSessionSpy: URLSessionProtocol {
    var dataTaskCallCount = 0
    var dataTaskArgsRequest: [URLRequest] = []

    var data: Data = Data()
    var response: HTTPURLResponse!
    var urlError: URLError!

    func erasedDataTaskPublisher(for request: URLRequest) -> AnyPublisher<APIResponse, URLError> {
        dataTaskCallCount += 1
        dataTaskArgsRequest.append(request)

        guard urlError == nil else {
            return Result.failure(urlError!).publisher.eraseToAnyPublisher()
        }

        return Result.success((data: data, response: response)).publisher.eraseToAnyPublisher()
    }
}
