//
//  URLRequest+Extensions.swift
//  MovieDB
//
//  Created by Fábio Salata on 05/11/20.
//

import Foundation

extension URLRequest {
    init(baseURL: String, target: ServiceTargetProtocol) throws {
        let parameters = target.parameters ?? [:]

        guard let url = URL(baseUrl: baseURL, path: target.path, parameters: parameters, method: target.method) else {
            throw APIError.Network.badURL
        }

        self.init(url: url)

        httpMethod = target.method.rawValue

        switch target.method {
        case .POST, .PUT:
            httpBody = target.body
        default:
            break
        }
    }
}
