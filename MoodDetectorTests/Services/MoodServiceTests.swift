//
//  MoodServiceTests.swift
//  MoodDetectorTests
//
//  Created by Fabio Cezar Salata on 16/04/21.
//

import XCTest
@testable import MoodDetector
import Combine

final class MoodServiceTests: XCTestCase {
    private var subscriptions = Set<AnyCancellable>()
    
    private var sut: MoodService!
    private var session: URLSessionSpy!
    
    override func setUp() {
        super.setUp()
        
        session = URLSessionSpy()
        let client = APIClient(session: session, api: MockAPI())
        sut = MoodService(client: client)
    }
    
    override func tearDown() {
        subscriptions.removeAll()
        sut = nil
        session = nil
        
        super.tearDown()
    }
    
    func test_fetchUserTweets_withSuccess() throws {
        let tweet = Tweet(id: "1", text: "Olá")
        
        let expectedURL = "https://mock.com/v1beta2/documents:analyzeSentiment"
        let expectedMagnitude = 1.3999999999999999
        let expetedScore = 0.69999999999999996
        
        session.data = mockHappySentimentResponse()
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
            .store(in: &subscriptions)

        let request = session.dataTaskArgsRequest.first
        
        XCTAssertEqual(request?.httpMethod, RequestMethod.POST.rawValue)
        let url = try XCTUnwrap(request?.url)
        
        let components = url.absoluteString.components(separatedBy: "?")
        XCTAssertEqual(components.first, expectedURL)
        
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
            } receiveValue: { response in
                XCTFail()
            }
            .store(in: &subscriptions)

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
            } receiveValue: { response in
                XCTFail()
            }
            .store(in: &subscriptions)

        XCTAssertNotNil(result)
        XCTAssertEqual(result, APIError.service(.internalServerError))
    }

}
