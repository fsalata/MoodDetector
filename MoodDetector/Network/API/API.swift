//
//  API.swift
//  MovieDB
//
//  Created by Fábio Salata on 05/11/20.
//

import Foundation

struct TwitterAPI: APIProtocol {
    let baseURL = "https://api.twitter.com"
}

struct GoogleAPI: APIProtocol {
    let baseURL = "https://language.googleapis.com"
}
