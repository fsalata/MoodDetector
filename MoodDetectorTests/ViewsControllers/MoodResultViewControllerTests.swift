//
//  MoodResultViewControllerTests.swift
//  MoodDetectorTests
//
//  Created by Fabio Cezar Salata on 17/04/21.
//

import XCTest
@testable import MoodDetector

final class MoodResultViewControllerTests: XCTestCase {

    private var sut: MoodResultViewController!
    private var coordinator: MockMoodResultCoordinator!
    
    private var feedbackViewButtonTapped = false
    
    override func setUp() {
        super.setUp()
        
        coordinator = MockMoodResultCoordinator(tweet: Tweet(id: "1", text: "olá"), navigationController: UINavigationController())
        coordinator.start()
        
        coordinator.session.data = mockNeutralSentimentResponse()
        coordinator.session.response = HTTPURLResponse(url: URL(string: MockAPI().baseURL)!, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        if let viewController = coordinator.navigationController.viewControllers.first as? MoodResultViewController {
            sut = viewController
        }
    }

    override func tearDown() {
        sut = nil
        coordinator = nil
        feedbackViewButtonTapped = false
        
        super.tearDown()
    }

    func test_Outlets_notNil() {
        sut.loadViewIfNeeded()
        
        XCTAssertNotNil(sut.emojiLabel)
    }
    
    func test_initalState() {
        sut.loadViewIfNeeded()
        
        XCTAssertEqual(sut.state, ViewState.loading)
        XCTAssertFalse(sut.view.subviews.contains(sut.feedbackView))
        XCTAssertFalse(sut.view.subviews.contains(sut.loadingView))
    }
    
    func test_showNeutralEmoji() {
        sut.loadViewIfNeeded()
        
        let promise = XCTKVOExpectation(keyPath: "text",
                                        object: sut.emojiLabel!,
                                        expectedValue: MoodEmoji.neutral.rawValue)
        
        let result = XCTWaiter().wait(for: [promise], timeout: timeout)
        
        XCTAssertTrue(result == .completed)
    }
    
    func test_showHappyEmoji() {
        coordinator.session.data = mockHappySentimentResponse()
        
        sut.loadViewIfNeeded()
        
        let promise = XCTKVOExpectation(keyPath: "text",
                                        object: sut.emojiLabel!,
                                        expectedValue: MoodEmoji.happy.rawValue)
        
        let result = XCTWaiter().wait(for: [promise], timeout: timeout)
        
        XCTAssertTrue(result == .completed)
    }
    
    func test_showSadEmoji() {
        coordinator.session.data = mockSadSentimentResponse()
        
        sut.loadViewIfNeeded()
        
        let promise = XCTKVOExpectation(keyPath: "text",
                                        object: sut.emojiLabel!,
                                        expectedValue: MoodEmoji.sad.rawValue)
        
        let result = XCTWaiter().wait(for: [promise], timeout: timeout)
        
        XCTAssertTrue(result == .completed)
    }
    
    func test_serviceError() {
        let expectedFeedbackMessage = "Ocorreu um erro com a sua solicitação"
        let expectedButtonTitle = "Tentar novamente"
        
        coordinator.session.response = HTTPURLResponse(url: URL(string: MockAPI().baseURL)!, statusCode: 500, httpVersion: nil, headerFields: nil)
        
        let promise = XCTKVOExpectation(keyPath: "text",
                                        object: sut.feedbackView.messageLabel!,
                                        expectedValue: expectedFeedbackMessage)
        
        sut.loadViewIfNeeded()
        
        let result = XCTWaiter().wait(for: [promise], timeout: timeout)
        
        XCTAssertTrue(result == .completed)
        XCTAssertEqual(sut.feedbackView.button.titleLabel?.text, expectedButtonTitle)
    }
    
    func test_serviceErrorButtonTap() {
        coordinator.session.response = HTTPURLResponse(url: URL(string: MockAPI().baseURL)!, statusCode: 500, httpVersion: nil, headerFields: nil)
        
        let promise = XCTKVOExpectation(keyPath: "text", object: sut.feedbackView.messageLabel!)
        
        sut.loadViewIfNeeded()
        
        sut.feedbackView.delegate = self
        
        let result = XCTWaiter().wait(for: [promise], timeout: timeout)
        
        XCTAssertTrue(result == .completed)
        
        tap(sut.feedbackView.button)
        
        XCTAssertTrue(feedbackViewButtonTapped)
    }
}

// MARK: - FeedbackViewDelegate
extension MoodResultViewControllerTests: FeedbackViewDelegate {
    func feedbackViewPerformAction(_ feedbackView: FeedbackView) {
        feedbackViewButtonTapped = true
    }
}

// MARK: - MoodResultCoordinator mock
class MockMoodResultCoordinator: MoodResultCoordinator {
    
    var session: URLSessionSpy!
    
    override var viewModel: MoodResultViewModel {
        session = URLSessionSpy()
        let client = APIClient(session: session, api: MockAPI())
        let service = MoodService(client: client)
        
        return MoodResultViewModel(tweet: Tweet(id: "1", text: "olá"), service: service)
    }
}
