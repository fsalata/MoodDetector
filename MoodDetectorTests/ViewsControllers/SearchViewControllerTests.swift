//
//  SearchViewControllerTests.swift
//  MoodDetectorTests
//
//  Created by Fabio Cezar Salata on 17/04/21.
//

import XCTest
@testable import MoodDetector

final class SearchViewControllerTests: XCTestCase {
    
    private var sut: SearchViewController!
    
    private var presentTweetResultCalled = false
    private var username = ""
    
    override func setUp() {
        super.setUp()
        
        let coordinator = MockSearchCoordinator(navigationController: UINavigationController())
        coordinator.delegate = self
        coordinator.start()
        
        if let viewController = coordinator.navigationController.viewControllers.first as? SearchViewController {
            sut = viewController
        }
    }

    override func tearDown() {
        sut = nil
        presentTweetResultCalled = false
        username = ""
        
        super.tearDown()
    }
    
    func test_outlets_notNil() {
        sut.loadViewIfNeeded()
        
        XCTAssertNotNil(sut.logoImageView)
        XCTAssertNotNil(sut.searchInfoLabel)
        XCTAssertNotNil(sut.usernameTextField)
        XCTAssertNotNil(sut.searchButton)
        XCTAssertNotNil(sut.errorMessageLabel)
    }
    
    func test_componentsInitalValues() {
        let expectedMessage = "Pesquisar tweets do usuário:"
        let expectedTitle = "Mood Detector"
        
        sut.loadViewIfNeeded()
        
        XCTAssertEqual(sut.title, expectedTitle)
        XCTAssertEqual(sut.searchInfoLabel.text, expectedMessage)
        XCTAssertTrue(sut.usernameTextField.text?.isEmpty ?? false)
        XCTAssertTrue(sut.errorMessageLabel.isHidden)
    }
    
    func test_showEmptyErroMessage() {
        sut.loadViewIfNeeded()
        
        tap(sut.searchButton)
        
        XCTAssertFalse(sut.errorMessageLabel.isHidden)
    }
    
    func test_searchUsername() {
        sut.loadViewIfNeeded()
        
        sut.usernameTextField.text = "binccp"
        
        tap(sut.searchButton)
    
        XCTAssertTrue(presentTweetResultCalled)
        XCTAssertEqual(username, sut.usernameTextField.text)
    }
}

// MARK: - MockSearchCoordinatorDelegate
extension SearchViewControllerTests: MockSearchCoordinatorDelegate {
    func presentTweetResultCalled(username: String) {
        presentTweetResultCalled = true
        self.username = username
    }
}

// MARK: - SearchCoordinator mock
fileprivate protocol MockSearchCoordinatorDelegate: AnyObject {
    func presentTweetResultCalled(username: String)
}

fileprivate class MockSearchCoordinator: SearchCoordinator {
    weak var delegate: MockSearchCoordinatorDelegate?
    
    override func presentTweetResult(for username: String) {
        delegate?.presentTweetResultCalled(username: username)
        super.presentTweetResult(for: username)
    }
}
