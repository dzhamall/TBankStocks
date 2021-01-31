//
//  NetworkServiceMock.swift
//  TinkoffStocksTests
//
//  Created by dzhamall on 31.01.2021.
//

import TinkoffStocks
import Foundation

struct NetworkSessionMock: NetworkSession {

    let response: HTTPURLResponse?
    let data: Data?
    let error: Error?

    func loadData(from request: URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        completion(data, response, error)
    }
}
