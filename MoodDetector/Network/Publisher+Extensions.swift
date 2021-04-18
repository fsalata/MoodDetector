//
//  Publisher+Extensions.swift
//  PublicGists
//
//  Created by Fabio Cezar Salata on 13/04/21.
//

import Foundation
import Combine

typealias URLResponseType = (data:  Data, response: URLResponse)

extension Publisher where Output == URLResponseType {
    
    /// Extract data from response
    func extractData() -> Publishers.TryMap<Self, Data> {
        tryMap { data, response in
            if let response = response as? HTTPURLResponse,
               !(200..<300 ~= response.statusCode) {
                throw APIError(response)
            }
            
            return data
        }
    }
    
    // Print API request/response data
    func debugResponse(request: URLRequest) -> Publishers.HandleEvents<Self> {
        handleEvents(receiveOutput: { output in
            #if DEBUG
            Swift.print("============================ REQUEST ============================")
            Swift.print("\nURL: \(request.url?.absoluteString ?? "")")
            
            Swift.print("\nMETHOD: \(request.httpMethod ?? "")")
            
            if let requestHeader = request.allHTTPHeaderFields {
                if let data = try? JSONSerialization.data(withJSONObject: requestHeader, options: .prettyPrinted) {
                    Swift.print("\nHEADER: \(String(data: data, encoding: .utf8) ?? "")")
                }
            }
            
            if let requestBody = request.httpBody {
                if let jsonObject = try? JSONSerialization.jsonObject(with: requestBody) {
                    if let jsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted) {
                        Swift.print("\nBODY: \(String(data: jsonData, encoding: .utf8) ?? "")")
                    }
                }
            }
            
            Swift.print("\n============================ RESPONSE ============================")
            if let jsonObject = try? JSONSerialization.jsonObject(with: output.data) {
                if let jsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted) {
                    Swift.print(String(data: jsonData, encoding: .utf8) ?? "")
                }
            }
            
            Swift.print("\n==================================================================\n")
            #endif
        })
    }
}

extension Publisher where Output == Data {
    func decode<T: Decodable>(as type: T.Type = T.self, using decoder: JSONDecoder = .init()) -> Publishers.Decode<Self, T, JSONDecoder> {
        return decode(type: type, decoder: decoder)
    }
}
