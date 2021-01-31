//
//  QuoteStockEndpoint.swift
//  TinkoffStocks
//
//  Created by dzhamall on 30.01.2021.
//

import Foundation

enum QuoteStockEndpoint {
    case configureEndpoint(symbol: String)
}

extension QuoteStockEndpoint: Endpointable {
    typealias DecodeModel = QuoteStock

    var path: String {
        switch self {
            case .configureEndpoint(let symbol):
                return "/stable/stock/\(symbol)/quote"
        }
    }

    var queryParameters: Parameters {
        guard let token = Bundle.main.object(forInfoDictionaryKey: "DzhamallToken") as? String else {
            assertionFailure("Failed to get token")
            return [:]
        }
        return ["token": token]
    }

    var httpMethod: HTTPMethodType {
        return .get
    }

    var headers: HTTPHeaders {
        return [:]
    }
}
