//
//  NetworkConstant.swift
//  TinkoffStocks
//
//  Created by dzhamall on 30.01.2021.
//

import Foundation

typealias Parameters = [String:String]
typealias HTTPHeaders = [String:String]

struct QueryEncoding: ParametersEncodable { }

enum HTTPMethodType: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete  = "DELETE"
}

enum NetworkError: Error {
    case noResponseFromServer
    case parsingJSONFailure
    case rediraction(Error?)
    case clientErrorResponse(Error?)
    case serverError(Error?)
    case unrecognizedError(Error?)
    case configureUrlRequestFailure(Error?)
    case missing
}
