//
//  URLSessionProtocol.swift
//  PublicGists
//
//  Created by Fabio Cezar Salata on 13/04/21.
//

import Foundation
import Combine

typealias APIResponse = URLSession.DataTaskPublisher.Output

protocol URLSessionProtocol {
    func erasedDataTaskPublisher(for request: URLRequest) -> AnyPublisher<APIResponse, URLError>
}

extension URLSession: URLSessionProtocol {
    func erasedDataTaskPublisher(for request: URLRequest) -> AnyPublisher<APIResponse, URLError> {
        return dataTaskPublisher(for: request).eraseToAnyPublisher()
    }
}
