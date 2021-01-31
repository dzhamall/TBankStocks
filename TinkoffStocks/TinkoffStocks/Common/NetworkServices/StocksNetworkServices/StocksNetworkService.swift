//
//  StocksNetworkService.swift
//  TinkoffStocks
//
//  Created by dzhamall on 30.01.2021.
//

import Foundation

final public class StocksNetworkService: NetworkService {

    private let session: NetworkSession

    init(session: NetworkSession) {
        self.session = session
    }

    public func request<T: Endpointable>(endpoint: T, completion: @escaping (Result<T.DecodeModel?, NetworkError>) -> Void) {
        do {
            let request = try endpoint.configureURLRequest()
            session.loadData(from: request) { [weak self] (data, response, error) in
                self?.handleLoadData(completion: completion, endpoint: endpoint, data: data, response: response, error: error)
            }
        } catch {
            completion(.failure(.configureUrlRequestFailure(
                                    NSError(domain: "Url address is outdated and no longer valid ", code: 0, userInfo: nil))
            ))
        }
    }
}
