//
//  EndpointProtocol.swift
//  TinkoffStocks
//
//  Created by dzhamall on 30.01.2021.
//

import Foundation

public protocol Endpointable {
    associatedtype DecodeModel: Decodable

    var baseURLString: String { get }
    var path: String { get }
    var queryParameters: Parameters { get }
    var httpMethod: HTTPMethodType { get }
    var headers: HTTPHeaders { get }

    /// Настройка url запроса по заданным проперти
    func configureURLRequest() throws -> URLRequest

    /// Получить модельку по которой будем парсить JSON
    func obtainDecodeModel() -> DecodeModel.Type
}

public extension Endpointable {

    var baseURLString: String {
        return "https://cloud.iexapis.com"
    }

    func configureURLRequest() throws -> URLRequest {
        let request = try buildRequest()
        return request
    }

    private func buildRequest() throws -> URLRequest {
        guard let url = URL(string: baseURLString + path) else { throw NSError(domain: "", code: 0, userInfo: nil) }
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        request.allHTTPHeaderFields = headers
        try configurationParameters(queryParameters: queryParameters, request: &request)
        return request
    }

    private func configurationParameters(queryParameters: Parameters?, request: inout URLRequest) throws {
        guard let queryParameters = queryParameters else { return }
        try QueryEncoding.encode(parameters: queryParameters, urlRequest: &request)
    }

    func obtainDecodeModel() -> DecodeModel.Type {
        return DecodeModel.self
    }
}
