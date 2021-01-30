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
        let presenter = StocksPresenter()
        let viewController = StocksViewController(output: presenter)

        presenter.view = viewController
        return viewController
    }
}
