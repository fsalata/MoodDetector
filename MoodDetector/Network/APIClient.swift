//
//  APIClient.swift
//  MovieDB
//
//  Created by Fábio Salata on 05/11/20.
//

import Foundation
import Combine

class APIClient {
    private var session: URLSessionProtocol
    private var api: APIProtocol
    
    init(session: URLSessionProtocol = URLSession.shared,
         api: APIProtocol) {
        self.session = session
        self.api = api
    }
    
    func request<T: Decodable>(target: ServiceTargetProtocol) -> AnyPublisher<T, APIError> {
        guard var urlRequest = try? URLRequest(baseURL: api.baseURL, target: target) else {
            return Fail(error: APIError.network(.badURL)).eraseToAnyPublisher()
        }
        
        urlRequest.allHTTPHeaderFields = target.header
        
        return session.erasedDataTaskPublisher(for: urlRequest)
            .retry(1)
            .mapError { error in
                return APIError(error)
            }
            .debugResponse(request: urlRequest)
            .extractData()
            .decode()
            .mapError { error in
                return error as? APIError ?? APIError.unknown
            }
            .eraseToAnyPublisher()
    }
}

