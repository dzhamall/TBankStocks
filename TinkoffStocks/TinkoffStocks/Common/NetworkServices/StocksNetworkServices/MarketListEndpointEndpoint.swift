//
//  StocksEndpoint.swift
//  TinkoffStocks
//
//  Created by dzhamall on 30.01.2021.
//

import Foundation

enum MarketListEndpoint {
    case configureEndpoint
}

// MARK: - Endpointable
extension MarketListEndpoint: Endpointable {
    typealias DecodeModel = [QuoteStock]

    var path: String {
        return "/stable/stock/market/list/mostactive"
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
