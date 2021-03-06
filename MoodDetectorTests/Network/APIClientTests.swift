//
//  APIClientTests.swift
//  MoodDetectorTests
//
//  Created by Fabio Cezar Salata on 16/04/21.
//

import XCTest
import Combine
@testable import MoodDetector

final class APIClientTests: XCTestCase {
    private var subscriptions = Set<AnyCancellable>()
    
    private var sut: APIClient!
    private var session: URLSessionSpy!
    
    override func setUp() {
        super.setUp()
        
        session = URLSessionSpy()
        sut = APIClient(session: session, api: MockAPI())
    }
    
    override func tearDown() {
        subscriptions.removeAll()
        sut = nil
        session = nil
        
        super.tearDown()
    }
    

    func test_APIGet_withSuccess() throws {
        session.data = mockTweetResponse()
        session.response = HTTPURLResponse(url: URL(string: MockAPI().baseURL)!, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        let publisher: AnyPublisher<SearchResult, APIError> = sut.request(target: MockGETServiceTarget.mock(page: 10))
        
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
            .store(in: &subscriptions)

        let request = session.dataTaskArgsRequest.first
        
        XCTAssertEqual(request?.httpMethod, RequestMethod.GET.rawValue)
        let url = try XCTUnwrap(request?.url)
        XCTAssertEqual(url.absoluteString, "https://mock.com/mock/mocking?page=10")
        XCTAssertNotNil(result)
    }
    
    func test_APIPost_withSuccess() {
        session.data = mockTweetResponse()
        session.response = HTTPURLResponse(url: URL(string: MockAPI().baseURL)!, statusCode: 201, httpVersion: nil, headerFields: nil)
        
        let publisher: AnyPublisher<SearchResult, APIError> = sut.request(target: MockPOSTServiceTarget.mock(page: 0))
        
        var result: SearchResult?
        
        publisher
            .sink { completion in
                switch completion {
                case .failure(let error):
                    XCTFail(error.localizedDescription)
                default:
                    break
                }
            } receiveValue: { response in
                result = response
            }
            .store(in: &subscriptions)
        
        let request = session.dataTaskArgsRequest.first
        
        XCTAssertEqual(request?.httpMethod, RequestMethod.POST.rawValue)
        XCTAssertNotNil(result)
    }
    
    func test_APIClient_withNetworkFailure() {
        session.urlError = URLError(.badURL)
        
        let publisher: AnyPublisher<SearchResult, APIError> = sut.request(target: MockGETServiceTarget.mock(page: 0))
        
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
    
    func test_APIClient_withServiceFailure() {
        session.response = HTTPURLResponse(url: URL(string: MockAPI().baseURL)!, statusCode: 500, httpVersion: nil, headerFields: nil)
        
        let publisher: AnyPublisher<SearchResult, APIError> = sut.request(target: MockGETServiceTarget.mock(page: 0))
        
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
    
    func test_APIClient_withParseFailure() {
        session.data = mockEmptyResponse()
        session.response = HTTPURLResponse(url: URL(string: MockAPI().baseURL)!, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        let publisher: AnyPublisher<SearchResult, APIError> = sut.request(target: MockGETServiceTarget.mock(page: 0))
        
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
        XCTAssertEqual(result, APIError.parse(.dataCorrupted(debugDescription: "The given data was not valid JSON.")))
    }
}
