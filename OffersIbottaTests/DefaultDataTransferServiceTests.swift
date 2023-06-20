//
//  DefaultDataTransferServiceTests.swift
//  OffersIbottaTests
//
//  Created by Mariia on 6/13/23.
//

import XCTest
@testable import OffersIbotta

import XCTest

final class DefaultDataTransferServiceTests: XCTestCase {
    
    var dataTransferService: DefaultDataTransferService!
    var networkService: MockNetworkService!
    var errorLogger: MockDataTransferErrorLogger!

    override func setUp() {
        super.setUp()
        networkService = MockNetworkService()
        errorLogger = MockDataTransferErrorLogger()
        dataTransferService = DefaultDataTransferService(with: networkService, errorLogger: errorLogger)
    }
    
    override func tearDown() {
        dataTransferService = nil
        networkService = nil
        errorLogger = nil
        super.tearDown()
    }
    
    func testRequest_Success() {
        // Given
        let expectedResult = TestModel(id: 1, name: "Test")
        let endpoint = Endpoint(path: .fileName("test.json"), responseDecoder: MockResponseDecoder(result: expectedResult))
        let responseData = Data()
        
        networkService.mockResult = .success(responseData)
        
        let expectation = XCTestExpectation(description: "Completion called")
        
        // When
        dataTransferService.request(with: endpoint) { (result: Result<TestModel, DataTransferError>) in
            // Then
            switch result {
            case .success(let result):
                XCTAssertEqual(result, expectedResult)
                expectation.fulfill()
            case .failure:
                XCTFail("Expected success, got failure")
            }
        }
        
        wait(for: [expectation], timeout: 1.0)
        XCTAssertTrue(networkService.requestCalled)
    }
    
    func testRequest_Failure() {
        // Given
        let endpoint = Endpoint(path: .fileName("test.json"))
        let error = NetworkError.urlGeneration
        
        networkService.mockResult = .failure(error)
        
        let expectation = XCTestExpectation(description: "Completion called")
        
        // When
        dataTransferService.request(with: endpoint) { (result: Result<TestModel, DataTransferError>) in
            // Then
            switch result {
            case .success:
                XCTFail("Expected failure, got success")
            case .failure(let dataTransferError):
                guard case .networkFailure = dataTransferError else {
                    XCTFail("Expected networkFailure, got \(dataTransferError)")
                    return
                }
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 1.0)
        XCTAssertTrue(networkService.requestCalled)
        XCTAssertTrue(errorLogger.logCalled)
    }
    
    // MARK: - Helper Classes
    
    enum TestError: Error {
        case testError
    }
    
    struct TestModel: Codable, Equatable {
        let id: Int
        let name: String
    }
    
    class MockNetworkService: NetworkService {
        var mockResult: Result<Data, NetworkError>?
        var requestCalled = false
        
        func request(path: PathType, completion: @escaping CompletionHandler) {
            requestCalled = true
            if let mockResult = mockResult {
                completion(mockResult)
            }
        }
    }
    
    class MockDataTransferErrorLogger: DataTransferErrorLogger {
        var logCalled = false
        
        func log(error: Error) {
            logCalled = true
        }
    }
    
    class MockResponseDecoder: ResponseDecoder {
        var result: Any?
        
        init(result: Any? = nil) {
            self.result = result
        }
        
        func decode<T: Decodable>(_ data: Data) throws -> T {
            guard let result = result as? T else {
                throw NSError(domain: "TestError", code: 123, userInfo: nil)
            }
            return result
        }
    }
}
