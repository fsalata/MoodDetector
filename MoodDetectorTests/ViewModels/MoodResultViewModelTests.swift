//
//  MoodResultViewModelTests.swift
//  MoodDetectorTests
//
//  Created by Fabio Cezar Salata on 17/04/21.
//

import XCTest
@testable import MoodDetector
import Combine

class MoodResultViewModelTests: XCTestCase {
    var subscriptions = Set<AnyCancellable>()
    
    var sut: MoodResultViewModel!
    var session: URLSessionSpy!
    
    override func setUp() {
        session = URLSessionSpy()
        let client = APIClient(session: session, api: MockAPI())
        let service = MoodService()
        service.client = client
        
        sut = MoodResultViewModel(tweet: Tweet(id: "1", text: "olá"), service: service)
    }
    
    override func tearDown() {
        subscriptions = []
        
        sut = nil
        session = nil
    }

    func test_tweet_withSuccess() {
        let expectedTweet = Tweet(id: "1", text: "olá")
        
        XCTAssertEqual(sut.tweet, expectedTweet)
    }
    
    func test_fetchHappyAnalysis_withSuccess() {
        let expectedSentiment = MoodEmoji.happy.rawValue
        
        session.data = mockHappySentimentResponse()
        session.response = HTTPURLResponse(url: URL(string: MockAPI().baseURL)!, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        sut.$sentiment
            .sink { _ in
            }
            .store(in: &subscriptions)
        
        sut.fetchAnalysis()
        
        XCTAssertNotNil(sut.sentiment)
        XCTAssertEqual(sut.sentiment, expectedSentiment)
        
        XCTAssertNil(sut.error)
    }
    
    func test_fetchNeutralAnalysis_withSuccess() {
        let expectedSentiment = MoodEmoji.neutral.rawValue
        
        session.data = mockNeutralSentimentResponse()
        session.response = HTTPURLResponse(url: URL(string: MockAPI().baseURL)!, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        sut.$sentiment
            .sink { _ in
            }
            .store(in: &subscriptions)
        
        sut.fetchAnalysis()
        
        XCTAssertNotNil(sut.sentiment)
        XCTAssertEqual(sut.sentiment, expectedSentiment)
        
        XCTAssertNil(sut.error)
    }
    
    func test_fetchSadAnalysis_withSuccess() {
        let expectedSentiment = MoodEmoji.sad.rawValue
        
        session.data = mockSadSentimentResponse()
        session.response = HTTPURLResponse(url: URL(string: MockAPI().baseURL)!, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        sut.$sentiment
            .sink { _ in
            }
            .store(in: &subscriptions)
        
        sut.fetchAnalysis()
        
        XCTAssertNotNil(sut.sentiment)
        XCTAssertEqual(sut.sentiment, expectedSentiment)
        
        XCTAssertNil(sut.error)
    }
    
    func test_fetchAnalysis_withSuccess() {
        let expectedError = APIError.service(.internalServerError)
        
        session.data = mockNeutralSentimentResponse()
        session.response = HTTPURLResponse(url: URL(string: MockAPI().baseURL)!, statusCode: 500, httpVersion: nil, headerFields: nil)
        
        sut.$error
            .sink { _ in
            }
            .store(in: &subscriptions)
        
        sut.fetchAnalysis()
        
        XCTAssertNotNil(sut.error)
        XCTAssertEqual(sut.error, expectedError)
        
        XCTAssertNil(sut.sentiment)
    }
}
