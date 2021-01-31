//
//  NetworkService.swift
//  TinkoffStocks
//
//  Created by dzhamall on 30.01.2021.
//

import Foundation

/// Протокол для сетевых сервисов.  Любой сервис,  который вы хотите использовать для взаимодействия с сетью, должен конформить данный протокол.
public protocol NetworkService {

    /// Запрос в сеть
    /// - Parameters:
    ///   - endpoint: Конечная точка url запроса
    ///   - completion: @escaping closure,  в которой могут быть данные либо ошибка от сервера
    func request<T:Endpointable>(endpoint: T, completion: @escaping (Result<T.DecodeModel?,NetworkError>) -> Void)
}

public extension NetworkService {

    func handleLoadData<T: Endpointable>(
        completion: @escaping (Result<T.DecodeModel?, NetworkError>) -> Void,
        endpoint: T,
        data: Data?,
        response: URLResponse?,
        error: Error?
    ) {
        guard let response = response as? HTTPURLResponse else {
            completion(.failure(.noResponseFromServer))
            return
        }
        if (error != nil) || handlе(statusCode: response.statusCode, error: nil) != nil {
            let networkError = handlе(statusCode: response.statusCode, error: error)
            completion(.failure(networkError ?? .unrecognizedError(error)))
            return
        } else {
            guard let data = data else {
                completion(.failure(.responseDataEmpty(NSError(domain: "Пустой ответ от сервера", code: 0, userInfo: nil))))
                return
            }
            do {
                let dataModel = try processDecode(endpoint: endpoint, data: data)
                completion(.success(dataModel))
            } catch { completion(.failure(.parsingJSONFailure)) }
        }
    }

    private func processDecode<T: Endpointable>(endpoint: T, data: Data?) throws -> T.DecodeModel? {
        guard let data = data else { throw NetworkError.noResponseFromServer }
        do {
            let response = try JSONDecoder().decode(endpoint.obtainDecodeModel().self, from: data)
            return response
        } catch { throw NetworkError.parsingJSONFailure }
    }

    private func handlе(statusCode: Int, error: Error?) -> NetworkError? {
        switch statusCode {
        case 200..<300:
            return nil
        case 300..<400:
            return .rediraction(error)
        case 400..<500:
            return .clientErrorResponse(error)
        case 500..<600:
            return .serverError(error)
        default:
            return .unrecognizedError(error)
        }
    }
}
