//
//  StockModel.swift
//  TinkoffStocks
//
//  Created by dzhamall on 30.01.2021.
//

import Foundation

struct StockModel {

    private(set) var changePrice: String
    let symbol: String
    let companyName: String
    let latestPrice: String
    let priceHesitation: StockModel.PriceHesitation
    let high: Double?
    let highTime: Double?
    let low: Double?
    let lowTime: Double?
    let iexOpen: Double?
    let iexOpenTime: Int?
    let iexClose: Double?
    let iexCloseTime: Int?
    let week52low: Double?
    let week52High: Double?

    enum PriceHesitation {
        case positive, negative, unchanged
    }
}

extension StockModel {

    init(responseMarketModel: QuoteStock) {
        symbol = responseMarketModel.symbol ?? String.Stocks.missingStringValue
        companyName = responseMarketModel.companyName ?? String.Stocks.missingStringValue
        if let responsePrice = responseMarketModel.latestPrice {
            latestPrice = String(responsePrice)
        } else {
            latestPrice = String.Stocks.missingDoubleValue
        }
        if let responseChangePrice = responseMarketModel.change {
            changePrice = String(responseChangePrice)
        } else {
            changePrice = String.Stocks.missingDoubleValue
        }
        if let responseChangePercentPrice = responseMarketModel.changePercent {
            changePrice += " (\(responseChangePercentPrice) %)"
        }
        if let responseChangePrice = responseMarketModel.change {
            if responseChangePrice > 0 {
                priceHesitation = .positive
            } else if responseChangePrice < 0 {
                priceHesitation = .negative
            } else {
                priceHesitation = .unchanged
            }
        } else {
            priceHesitation = .unchanged
        }
        high = responseMarketModel.high
        highTime = responseMarketModel.highTime
        low = responseMarketModel.low
        lowTime = responseMarketModel.lowTime
        iexOpen = responseMarketModel.iexOpen
        iexOpenTime = responseMarketModel.iexOpenTime
        iexClose = responseMarketModel.iexClose
        iexCloseTime = responseMarketModel.iexCloseTime
        week52low = responseMarketModel.week52low
        week52High = responseMarketModel.week52High
    }
}
