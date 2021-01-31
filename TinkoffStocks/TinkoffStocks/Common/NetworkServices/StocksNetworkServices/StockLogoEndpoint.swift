//
//  StockLogoEndpoint.swift
//  TinkoffStocks
//
//  Created by dzhamall on 31.01.2021.
//

import Foundation

enum StockLogoEndpoint {
    case configureEndpoint(symbol: String)
}

extension StockLogoEndpoint: Endpointable {
    typealias DecodeModel = StockLogo

    var path: String {
        switch self {
            case .configureEndpoint(let symbol):
                return "/stable/stock/\(symbol)/logo"
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
