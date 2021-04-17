//
//  MoodResultViewControllerTests.swift
//  MoodDetectorTests
//
//  Created by Fabio Cezar Salata on 17/04/21.
//

import XCTest
@testable import MoodDetector

class MoodResultViewControllerTests: XCTestCase {

    var sut: MoodResultViewController!
    var coordinator: MockMoodResultCoordinator!
    
    var feedbackViewButtonTapped = false
    
    override func setUp() {
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
        
        let promise = XCTKVOExpectation(keyPath: "text", object: sut.emojiLabel!)
        
        let result = XCTWaiter().wait(for: [promise], timeout: 1.0)
        
        XCTAssertTrue(result == .completed)
        XCTAssertEqual(sut.emojiLabel.text, MoodEmoji.neutral.rawValue)
    }
    
    func test_showHappyEmoji() {
        coordinator.session.data = mockHappySentimentResponse()
        
        sut.loadViewIfNeeded()
        
        let promise = XCTKVOExpectation(keyPath: "text", object: sut.emojiLabel!)
        
        let result = XCTWaiter().wait(for: [promise], timeout: 1.0)
        
        XCTAssertTrue(result == .completed)
        
        XCTAssertEqual(sut.emojiLabel.text, MoodEmoji.happy.rawValue)
    }
    
    func test_showFrustratedEmoji() {
        coordinator.session.data = mockFrustratedSentimentResponse()
        
        sut.loadViewIfNeeded()
        
        let promise = XCTKVOExpectation(keyPath: "text", object: sut.emojiLabel!)
        
        let result = XCTWaiter().wait(for: [promise], timeout: 1.0)
        
        XCTAssertTrue(result == .completed)
        XCTAssertEqual(sut.emojiLabel.text, MoodEmoji.frustrated.rawValue)
    }
    
    func test_serviceError() {
        let expectedFeedbackMessage = "Ocorreu um erro com a sua solicitação"
        let expectedButtonTitle = "Tentar novamente"
        
        coordinator.session.response = HTTPURLResponse(url: URL(string: MockAPI().baseURL)!, statusCode: 500, httpVersion: nil, headerFields: nil)
        
        let promise = XCTKVOExpectation(keyPath: "text", object: sut.feedbackView.messageLabel!)
        
        sut.loadViewIfNeeded()
        
        let result = XCTWaiter().wait(for: [promise], timeout: 1.0)
        
        XCTAssertTrue(result == .completed)
        XCTAssertEqual(sut.feedbackView.messageLabel.text, expectedFeedbackMessage)
        XCTAssertEqual(sut.feedbackView.button.titleLabel?.text, expectedButtonTitle)
    }
    
    func test_serviceErrorButtonTap() {
        coordinator.session.response = HTTPURLResponse(url: URL(string: MockAPI().baseURL)!, statusCode: 500, httpVersion: nil, headerFields: nil)
        
        let promise = XCTKVOExpectation(keyPath: "text", object: sut.feedbackView.messageLabel!)
        
        sut.loadViewIfNeeded()
        
        sut.feedbackView.delegate = self
        
        let result = XCTWaiter().wait(for: [promise], timeout: 1.0)
        
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
        let service = MoodService()
        service.client = client
        
        return MoodResultViewModel(tweet: Tweet(id: "1", text: "olá"), service: service)
    }
}
