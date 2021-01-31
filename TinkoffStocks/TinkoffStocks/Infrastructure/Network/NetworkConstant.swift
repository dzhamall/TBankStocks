//
//  NetworkConstant.swift
//  TinkoffStocks
//
//  Created by dzhamall on 30.01.2021.
//

import Foundation

public typealias Parameters = [String:String]
public typealias HTTPHeaders = [String:String]

public struct QueryEncoding: ParametersEncodable { }

public enum HTTPMethodType: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete  = "DELETE"
}

public enum NetworkError: Error {
    case noResponseFromServer
    case parsingJSONFailure
    case rediraction(Error?)
    case clientErrorResponse(Error?)
    case serverError(Error?)
    case unrecognizedError(Error?)
    case configureUrlRequestFailure(Error?)
    case responseDataEmpty(Error?)
    case missing
}
