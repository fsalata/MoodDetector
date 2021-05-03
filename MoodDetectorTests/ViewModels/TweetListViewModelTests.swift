//
//  TweetListViewModelTests.swift
//  MoodDetectorTests
//
//  Created by Fabio Cezar Salata on 17/04/21.
//

import XCTest
@testable import MoodDetector
import Combine

final class TweetListViewModelTests: XCTestCase {
    private var subscriptions = Set<AnyCancellable>()

    private var sut: TweetListViewModel!
    private var session: URLSessionSpy!

    override func setUp() {
        super.setUp()

        session = URLSessionSpy()
        let client = APIClient(session: session, api: MockAPI())
        let service = TweetListService(client: client)

        sut = TweetListViewModel(username: "binccp", service: service)
    }

    override func tearDown() {
        subscriptions.removeAll()
        sut = nil
        session = nil

        super.tearDown()
    }

    func test_usernama_withSuccess() {
        let expectedUsername = "binccp"

        XCTAssertEqual(sut.username, expectedUsername)
    }

    func test_fetchUserTweets_withSuccess() throws {
        let expectedTweets = try JSONDecoder().decode(SearchResult.self, from: mockTweetResponse()).data

        session.data = mockTweetResponse()
        session.response = HTTPURLResponse(url: URL(string: TwitterAPI().baseURL)!,
                                           statusCode: 200,
                                           httpVersion: nil,
                                           headerFields: nil)

        sut.$tweets
            .sink { _ in
            }
            .store(in: &subscriptions)

        sut.fetchUserTweets()

        XCTAssertNotNil(sut.tweets)
        XCTAssertEqual(sut.tweets, expectedTweets)

        XCTAssertNotNil(sut.meta)

        XCTAssertNil(sut.error)
    }

    func test_fetchUserTweets_withFailure() throws {
        let expectedError = APIError.service(.forbidden)

        session.data = mockTweetResponse()
        session.response = HTTPURLResponse(url: URL(string: TwitterAPI().baseURL)!,
                                           statusCode: 403,
                                           httpVersion: nil,
                                           headerFields: nil)

        sut.$error
            .sink { _ in
            }
            .store(in: &subscriptions)

        sut.fetchUserTweets()

        XCTAssertNotNil(sut.error)
        XCTAssertEqual(sut.error, expectedError)

        XCTAssertNil(sut.meta)

        XCTAssertNil(sut.tweets)
    }
}
