//
//  MoodServiceTests.swift
//  MoodDetectorTests
//
//  Created by Fabio Cezar Salata on 16/04/21.
//

import XCTest
@testable import MoodDetector
import Combine

class MoodServiceTests: XCTestCase {
    var subscribers = Set<AnyCancellable>()
    
    var sut: SearchService!
    var session: URLSessionSpy!
    
    override func setUp() {
        super.setUp()
        
        session = URLSessionSpy()
        let client = APIClient(session: session, api: MockAPI())
        sut = SearchService()
        sut.client = client
    }
    
    override func tearDown() {
        subscribers = []
        sut = nil
        session = nil
    }
    
    func test_fetchUserTweets_withSuccess() throws {
        let expectedURL = "https://mock.com//2/tweets/search/recent?query=from:binccp"
        let expectedText = "Wishing a safe and peaceful month of Ramadan to all those observing around the world. Ramadan Mubarak!"
        
        session.data = mockTweetResponse()
        session.response = HTTPURLResponse(url: URL(string: TwitterAPI().baseURL)!, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        let publisher: AnyPublisher<SearchResult, APIError> = sut.fetchUserRecentTweets(username: "binccp")
        
        var result: SearchResult?
        
        publisher
            .sink { completion in
                switch completion {
                case .failure(let error):
                    XCTFail(error.localizedDescription)
                default:
                    break
                }
            } receiveValue: { searchResult in
                result = searchResult
            }
            .store(in: &subscribers)

        let request = session.dataTaskArgsRequest.first
        
        XCTAssertEqual(request?.httpMethod, RequestMethod.GET.rawValue)
        let url = try XCTUnwrap(request?.url)
        XCTAssertEqual(url.absoluteString, expectedURL)
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.data?.count, 2)
        XCTAssertEqual(result?.data?.last?.text, expectedText)
    }
    
    func test_fetchUserTweets_withNetworkFailure() {
        session.urlError = URLError(.badURL)
        
        let publisher: AnyPublisher<SearchResult, APIError> = sut.fetchUserRecentTweets(username: "binccp")
        
        var result: APIError?
        
        publisher
            .sink { completion in
                switch completion {
                case .failure(let error):
                    result = error
                default:
                    break
                }
            } receiveValue: { movies in
                XCTFail()
            }
            .store(in: &subscribers)
        
        XCTAssertNotNil(result)
        XCTAssertEqual(result, APIError.network(.badURL))
    }
    
    func test_fetchUserTweets_withServiceFailure() {
        session.response = HTTPURLResponse(url: URL(string: TwitterAPI().baseURL)!, statusCode: 500, httpVersion: nil, headerFields: nil)
        
        let publisher: AnyPublisher<SearchResult, APIError> = sut.fetchUserRecentTweets(username: "binccp")
        
        var result: APIError?
        
        publisher
            .sink { completion in
                switch completion {
                case .failure(let error):
                    result = error
                default:
                    break
                }
            } receiveValue: { movies in
                XCTFail()
            }
            .store(in: &subscribers)
        
        XCTAssertNotNil(result)
        XCTAssertEqual(result, APIError.service(.internalServerError))
    }
}
