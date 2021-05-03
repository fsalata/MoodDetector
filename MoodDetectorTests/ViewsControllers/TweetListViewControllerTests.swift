//
//  TweetListViewControllerTests.swift
//  MoodDetectorTests
//
//  Created by Fabio Cezar Salata on 17/04/21.
//

import XCTest
@testable import MoodDetector

final class TweetListViewControllerTests: XCTestCase {

    private var sut: TweetListViewController!
    private var coordinator: MockTweetListCoordinator!

    private var presentMoodResultCalled = false
    private var tweet: Tweet?

    private var feedbackViewButtonTapped = false

    override func setUp() {
        super.setUp()

        coordinator = MockTweetListCoordinator(username: "binccp", navigationController: UINavigationController())
        coordinator.delegate = self
        coordinator.start()

        coordinator.session.data = mockTweetResponse()
        coordinator.session.response = HTTPURLResponse(url: URL(string: MockAPI().baseURL)!,
                                                       statusCode: 200,
                                                       httpVersion: nil,
                                                       headerFields: nil)

        if let viewController = coordinator.navigationController.viewControllers.first as? TweetListViewController {
            sut = viewController
        }
    }

    override func tearDown() {
        sut = nil
        coordinator = nil
        presentMoodResultCalled = false
        tweet = nil
        feedbackViewButtonTapped = false

        super.tearDown()
    }

    func test_Outlets_notNil() {
        sut.loadViewIfNeeded()

        XCTAssertNotNil(sut.tableView)
    }

    func test_initalState() {
        let expectedTitle = "Binccp tweets"

        sut.loadViewIfNeeded()

        XCTAssertEqual(sut.title, expectedTitle)
        XCTAssertEqual(sut.state, ViewState.loading)
        XCTAssertFalse(sut.view.subviews.contains(sut.feedbackView))
        XCTAssertFalse(sut.view.subviews.contains(sut.loadingView))
    }

    func test_tableViewData() {
        sut.loadViewIfNeeded()

        XCTAssertEqual(numberOfRows(in: sut.tableView), 2)
    }

    func test_tableViewCell() {
        let expectedTweetText = "Apple is proud to be carbon neutral &amp; by 2030 our products and manufacturing will be too. We take a new step today with a $200M fund to invest in working forests, one of nature’s best tools to remove carbon.🌳🌎 "

        sut.loadViewIfNeeded()

        if let cell = cellForRow(in: sut.tableView, row: 0) as? TweetsTableViewCell {
            XCTAssertEqual(cell.tweetLabel.text, expectedTweetText)
        }
    }

    func test_noTweetsFound() {
        let expectedFeedbackMessage = "Não foram encontrados resultados"
        let expectedButtonTitle = "Voltar"

        coordinator.session.data = mockNoTweetsResponse()

        let promise = XCTKVOExpectation(keyPath: "text",
                                        object: sut.feedbackView.messageLabel!,
                                        expectedValue: expectedFeedbackMessage)

        sut.loadViewIfNeeded()

        let result = XCTWaiter().wait(for: [promise], timeout: timeout)

        XCTAssertTrue(result == .completed)
        XCTAssertEqual(sut.feedbackView.button.titleLabel?.text, expectedButtonTitle)
    }

    func test_serviceError() {
        let expectedFeedbackMessage = "Ocorreu um erro com a sua solicitação"
        let expectedButtonTitle = "Tentar novamente"

        coordinator.session.response = HTTPURLResponse(url: URL(string: MockAPI().baseURL)!,
                                                       statusCode: 500,
                                                       httpVersion: nil,
                                                       headerFields: nil)

        let promise = XCTKVOExpectation(keyPath: "text",
                                        object: sut.feedbackView.messageLabel!,
                                        expectedValue: expectedFeedbackMessage)

        sut.loadViewIfNeeded()

        let result = XCTWaiter().wait(for: [promise], timeout: timeout)

        XCTAssertTrue(result == .completed)
        XCTAssertEqual(sut.feedbackView.button.titleLabel?.text, expectedButtonTitle)
    }

    func test_serviceErrorButtonTap() {
        coordinator.session.response = HTTPURLResponse(url: URL(string: MockAPI().baseURL)!,
                                                       statusCode: 500,
                                                       httpVersion: nil,
                                                       headerFields: nil)

        let promise = XCTKVOExpectation(keyPath: "text", object: sut.feedbackView.messageLabel!)

        sut.loadViewIfNeeded()

        sut.feedbackView.delegate = self

        let result = XCTWaiter().wait(for: [promise], timeout: timeout)

        XCTAssertTrue(result == .completed)

        tap(sut.feedbackView.button)

        XCTAssertTrue(feedbackViewButtonTapped)
    }

    func test_tapCell() {
        sut.loadViewIfNeeded()

        didSelectRow(in: sut.tableView, row: 0)

        XCTAssertTrue(presentMoodResultCalled)
    }
}

// MARK: - MockTweetListCoordinatorDelegate
extension TweetListViewControllerTests: MockTweetListCoordinatorDelegate {
    func presentMoodResultCalled(tweet: Tweet) {
        presentMoodResultCalled = true
        self.tweet = tweet
    }
}

// MARK: - FeedbackViewDelegate
extension TweetListViewControllerTests: FeedbackViewDelegate {
    func feedbackViewPerformAction(_ feedbackView: FeedbackView) {
        feedbackViewButtonTapped = true
    }
}

// MARK: - TweetListCoordinator mock
protocol MockTweetListCoordinatorDelegate: AnyObject {
    func presentMoodResultCalled(tweet: Tweet)
}

class MockTweetListCoordinator: TweetListCoordinator {

    var session: URLSessionSpy!

    weak var delegate: MockTweetListCoordinatorDelegate?

    override var viewModel: TweetListViewModel {
        session = URLSessionSpy()
        let client = APIClient(session: session, api: MockAPI())
        let service = TweetListService(client: client)

        return TweetListViewModel(username: "binccp", service: service)
    }

    override func presentMoodResult(tweet: Tweet) {
        delegate?.presentMoodResultCalled(tweet: tweet)
        super.presentMoodResult(tweet: tweet)
    }
}
