//
//  StocksPresentationFactory.swift
//  TinkoffStocks
//
//  Created by dzhamall on 30.01.2021.
//

import UIKit

protocol StocksPresentationFactory {

    func makeStocksPresentation() -> UIViewController
}

extension StocksPresentationFactory {

    func makeStocksPresentation() -> UIViewController {
        let networkService = StocksNetworkService(session: URLSession.shared)
        let anyImageLoader = AnyImageLoader()
        let presenter = StocksPresenter(networkService: networkService, anyImageLoader: anyImageLoader)
        let viewController = StocksViewController(output: presenter)

        presenter.view = viewController
        return viewController
    }
}
