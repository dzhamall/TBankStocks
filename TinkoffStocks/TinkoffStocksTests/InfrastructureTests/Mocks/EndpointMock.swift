//
//  EndpointMock.swift
//  TinkoffStocksTests
//
//  Created by dzhamall on 31.01.2021.
//

import TinkoffStocks

struct ResponseModelMock: Codable {
    let company: String
}

enum EndpointMock {
    case configureEndpoint
}

extension EndpointMock: Endpointable {
    typealias DecodeModel = ResponseModelMock

    var path: String {
        return ""
    }

    var queryParameters: Parameters {
        return [:]
    }

    var httpMethod: HTTPMethodType {
        return .get
    }

    var headers: HTTPHeaders {
        return [:]
    }
}
