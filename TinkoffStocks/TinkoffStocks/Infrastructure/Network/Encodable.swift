//
//  Encodable.swift
//  TinkoffStocks
//
//  Created by dzhamall on 30.01.2021.
//

import Foundation

protocol ParametersEncodable {

    /// Кодирует [String:String] в параметры url запроса
    /// - Parameters:
    ///   - parameters: [String:String] параметры
    ///   - urlRequest: url запрос в который кодируем параметры
    ///   - endpoint: конечная точка запроса
    static func encode(parameters: Parameters, urlRequest: inout URLRequest) throws
}

extension ParametersEncodable {

    static func encode(parameters: Parameters, urlRequest: inout URLRequest) throws {
        var queryItems = [URLQueryItem]()
        guard let url = urlRequest.url else { throw  NSError(domain: "", code: 0, userInfo: nil)}// RouterError.parameterEncode }
        if var components = URLComponents(url: url, resolvingAgainstBaseURL: false) {
            parameters.forEach {
                queryItems.append(URLQueryItem(name: $0.key, value: $0.value))
            }
            components.queryItems = !queryItems.isEmpty ? queryItems : components.queryItems
            urlRequest.url = components.url
        }
    }
    
}
