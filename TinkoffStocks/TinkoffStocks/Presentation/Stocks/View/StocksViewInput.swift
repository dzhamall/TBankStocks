//
//  StocksViewInput.swift
//  TinkoffStocks
//
//  Created by dzhamall on 30.01.2021.
//

import UIKit

protocol StocksViewInput: AnyObject {

    func displayStocksInfo()
    func display(logo: UIImage, model: StockModel)
    func dropInfos()
    func startActivityIndicator()
    func stopActivityIndicator()
    func updateStockInfo(withModel model: StockModel, initialIndex: Int?)
    func show(error: NetworkError)
    func showReachabilityError()
    
}
