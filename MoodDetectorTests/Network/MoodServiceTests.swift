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
    
    var sut: MoodService!
    var session: URLSessionSpy!
    
    override func setUp() {
        super.setUp()
        
        session = URLSessionSpy()
        let client = APIClient(session: session, api: MockAPI())
        sut = MoodService()
        sut.client = client
    }
    
    override func tearDown() {
        subscribers = []
        sut = nil
        session = nil
    }
    
    func test_fetchUserTweets_withSuccess() throws {
        let tweet = Tweet(id: "1", text: "Olá")
        
        let expectedURL = "https://mock.com//v1beta2/documents:analyzeSentiment?key=AIzaSyCrthPxP76XUOwmpvix289aioLK9yUfBRk"
        let expectedMagnitude = 1.3999999999999999
        let expetedScore = 0.69999999999999996
        
        session.data = mockSentimentResponse()
        session.response = HTTPURLResponse(url: URL(string: TwitterAPI().baseURL)!, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        let publisher: AnyPublisher<SentimentResult, APIError> = sut.analyzeTweetMood(tweet: tweet)
        
        var result: SentimentResult?
        
        publisher
            .sink { completion in
                switch completion {
                case .failure(let error):
                    XCTFail(error.localizedDescription)
                default:
                    break
                }
            } receiveValue: { sentimentResult in
                result = sentimentResult
            }
            .store(in: &subscribers)

        let request = session.dataTaskArgsRequest.first
        
        XCTAssertEqual(request?.httpMethod, RequestMethod.POST.rawValue)
        let url = try XCTUnwrap(request?.url)
        XCTAssertEqual(url.absoluteString, expectedURL)
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.documentSentiment.magnitude, expectedMagnitude)
        XCTAssertEqual(result?.documentSentiment.score, expetedScore)
    }
    
    func test_fetchUserTweets_withNetworkFailure() {
        let tweet = Tweet(id: "1", text: "Olá")
        
        session.urlError = URLError(.badURL)

        let publisher: AnyPublisher<SentimentResult, APIError> = sut.analyzeTweetMood(tweet: tweet)

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
        let tweet = Tweet(id: "1", text: "Olá")
        
        session.response = HTTPURLResponse(url: URL(string: TwitterAPI().baseURL)!, statusCode: 500, httpVersion: nil, headerFields: nil)

        let publisher: AnyPublisher<SentimentResult, APIError> = sut.analyzeTweetMood(tweet: tweet)

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
