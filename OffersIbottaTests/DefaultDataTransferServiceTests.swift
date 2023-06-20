//
//  DefaultDataTransferServiceTests.swift
//  OffersIbottaTests
//
//  Created by Mariia on 6/13/23.
//

import XCTest
@testable import OffersIbotta

import XCTest

import XCTest

class DefaultDataTransferServiceTests: XCTestCase {

    var networkService: MockNetworkService!
    var errorLogger: MockDataTransferErrorLogger!
    var dataTransferService: DefaultDataTransferService!
    
    let endpoint = Endpoint(path: .fileName("test.json"), responseDecoder: JSONResponseDecoder())

    override func setUp() {
        super.setUp()
        networkService = MockNetworkService()
        errorLogger = MockDataTransferErrorLogger()
        dataTransferService = DefaultDataTransferService(
            with: networkService,
            errorLogger: errorLogger
        )
    }

    override func tearDown() {
        networkService = nil
        errorLogger = nil
        dataTransferService = nil
        super.tearDown()
    }

    func testRequest_Success() {
        // Given
        let expectedResult = TestModel(id: 123, name: "Test")
        let jsonData = try! JSONEncoder().encode(expectedResult)
        networkService.mockResult = .success(jsonData)

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
        XCTAssertFalse(errorLogger.logCalled)
    }

    func testRequest_Failure_NetworkFailure() {
        // Given
        let error = NetworkError.loading(TestError.test)
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

    // MARK: - Helper

    struct TestModel: Codable, Equatable {
        let id: Int
        let name: String
    }

    enum TestError: Error {
        case test
    }
}

// MARK: - Mock Classes

class MockNetworkService: NetworkService {
    var requestCalled = false
    var mockResult: Result<Data?, NetworkError>?

    func request(path: PathType, completion: @escaping CompletionHandler) {
        requestCalled = true
        if let result = mockResult {
            switch result {
            case .success(let data):
                if let data {
                    completion(.success(data))
                }
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

class MockDataTransferErrorLogger: DataTransferErrorLogger {
    var logCalled = false

    func log(error: Error) {
        logCalled = true
    }
}

class JSONResponseDecoder: ResponseDecoder {
    private let jsonDecoder = JSONDecoder()

    func decode<T: Decodable>(_ data: Data) throws -> T {
        return try jsonDecoder.decode(T.self, from: data)
    }
}
