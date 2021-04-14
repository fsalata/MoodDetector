//
//  URL+Extension.swift
//  MovieDB
//
//  Created by Fábio Salata on 05/11/20.
//

import Foundation

typealias JSON = [String: Any]

extension URL {
    init?(baseUrl: String, path: String, parameters: JSON?, method: RequestMethod) {
        var components = URLComponents(string: baseUrl)!
        components.path += path
        
        switch method {
        case .GET, .DELETE:
            components.queryItems = parameters?.map {
                URLQueryItem(name: $0.key, value: String(describing: $0.value))
            }
        default:
            break
        }
        
        guard let url = components.url else { return nil }
        
        self = url
    }
}
