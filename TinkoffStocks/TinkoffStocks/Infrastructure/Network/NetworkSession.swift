//
//  NetworkSession.swift
//  TinkoffStocks
//
//  Created by dzhamall on 30.01.2021.
//

import Foundation

/// Обертка для URLSession.  Упрощает тестирование запросов
public protocol NetworkSession {

    /// Загрузить данные
    /// - Parameters:
    ///   - request: Необходимый запрос
    ///   - completion: @escaping closure, с базовыми параметрами для возврата данных, ответа от сервера или ошибки от URLSession data task
    func loadData(from request: URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> Void)
}

public extension NetworkSession where Self: URLSession {

    func loadData(from request: URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        var task: URLSessionDataTask?
        defer {
            task = nil
        }
        task = self.dataTask(with: request) { (data, response, error) in
            completion(data,response,error)
        }
        task?.resume()
    }
}

