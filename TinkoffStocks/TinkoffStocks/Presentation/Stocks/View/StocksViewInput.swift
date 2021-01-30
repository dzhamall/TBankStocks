//
//  StocksViewInput.swift
//  TinkoffStocks
//
//  Created by dzhamall on 30.01.2021.
//

import Foundation

protocol StocksViewInput: AnyObject {

    func displayStocksInfo()
    func updateStockInfo(withModel model: StockModel)
}
