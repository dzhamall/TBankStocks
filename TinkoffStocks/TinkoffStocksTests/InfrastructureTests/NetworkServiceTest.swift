//
//  NetworkServiceTest.swift
//  TinkoffStocksTests
//
//  Created by dzhamall on 31.01.2021.
//

import XCTest
@testable import TinkoffStocks

final class NetworkServiceTest: XCTestCase {

    func test_whenMockDataPassed_shouldReturnProperResponse() {
        let mockData = #"{"company": "Tinkoff"}"#.data(using: .utf8)
        let networkServiceMock = StocksNetworkService(session: NetworkSessionMock(response: HTTPURLResponse(),
                                                                                  data: mockData,
                                                                                  error: nil))
        let expectation = self.expectation(description: "Should return correct data")
        networkServiceMock.request(endpoint: EndpointMock.configureEndpoint) { result in
            switch result {
            case .success:
                expectation.fulfill()
            case .failure:
                XCTFail("Should return failure")
            }
        }
        wait(for: [expectation], timeout: 0.1)
    }

    func test_whenParsingError() {
        let mockData = #"{"": "Tinkoff"}"#.data(using: .utf8)
        let networkServiceMock = StocksNetworkService(session: NetworkSessionMock(response: HTTPURLResponse(),
                                                                                  data: mockData,
                                                                                  error: nil))
        let expectation = self.expectation(description: "Should return not correct data")
        networkServiceMock.request(endpoint: EndpointMock.configureEndpoint) { result in
            switch result {
            case .success:
                XCTFail("Should return correct response")
            case .failure(let error):
                switch error {
                case .parsingJSONFailure:
                    expectation.fulfill()
                default:
                    XCTFail("Should return not correct error")
                }
            }
        }
        wait(for: [expectation], timeout: 0.1)
    }

    func test_whenEmptyResponse() {
        let networkServiceMock = StocksNetworkService(session: NetworkSessionMock(response: nil,
                                                                                  data: nil,
                                                                                  error: nil))
        let expectation = self.expectation(description: "Should return error rediraction")
        networkServiceMock.request(endpoint: EndpointMock.configureEndpoint) { result in
            switch result {
            case .success:
                XCTFail("Should return correct response")
            case .failure(let error):
                switch error {
                case .noResponseFromServer:
                    expectation.fulfill()
                default:
                    XCTFail("Should return not correct error")
                }
            }
        }
        wait(for: [expectation], timeout: 0.1)
    }

    func test_whenEmptyResponseData() {
        let networkServiceMock = StocksNetworkService(session: NetworkSessionMock(response: HTTPURLResponse(),
                                                                                  data: nil,
                                                                                  error: nil))
        let expectation = self.expectation(description: "Should return not correct data")
        networkServiceMock.request(endpoint: EndpointMock.configureEndpoint) { result in
            switch result {
            case .success:
                XCTFail("Should return correct response")
            case .failure(let error):
                switch error {
                case .responseDataEmpty:
                    expectation.fulfill()
                default:
                    XCTFail("Should return not correct error")
                }
            }
        }
        wait(for: [expectation], timeout: 0.1)
    }
}
