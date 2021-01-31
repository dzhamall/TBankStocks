//
//  StockModel.swift
//  TinkoffStocks
//
//  Created by dzhamall on 30.01.2021.
//

import Foundation
import UIKit.UIColor

final class StockModel {

    private(set) var changePrice: String
    private(set) var maximumPrice: Float = 0.0
    let symbol: String
    let companyName: String
    let latestPrice: String
    let priceHesitation: StockModel.PriceHesitation
    let high: Float?
    let highTime: Double?
    let low: Float?
    let lowTime: Double?
    let iexOpen: Float?
    let iexOpenTime: Double?
    let iexClose: Float?
    let iexCloseTime: Double?
    let week52Low: Float?
    let week52High: Float?

    enum PriceHesitation {
        case positive, negative, unchanged
    }

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
        week52Low = responseMarketModel.week52Low
        week52High = responseMarketModel.week52High
    }
}

extension StockModel {

    func configureBarGraphStockEntity() -> [BarGraphStockEntity] {
        let sortedArray = [high, iexOpen, iexClose, week52High].compactMap { $0 }.sorted()
        let highEntity = BarGraphStockEntity(
            color: UIColor.Stocks.positivePriceChange,
            height: (high ?? 0),
            textValue: String(high ?? 0),
            title: highTime?.unixtimeToString() ?? "hight"
        )
        let lowEntity = BarGraphStockEntity(
            color: UIColor.Stocks.negativePriceChange,
            height: (low ?? 0),
            textValue: String(low ?? 0),
            title: lowTime?.unixtimeToString() ?? "low"
        )
        let iexOpenEntity = BarGraphStockEntity(
            color: UIColor.Stocks.iexOpenStockColor,
            height: (iexOpen ?? 0),
            textValue: String(iexOpen ?? 0),
            title: iexOpenTime?.unixtimeToString() ?? "iexOpen"
        )
        let iexCloseEntity = BarGraphStockEntity(
            color: UIColor.Stocks.iexCloseStockColor,
            height: (iexClose ?? 0),
            textValue: String(iexClose ?? 0),
            title: iexCloseTime?.unixtimeToString() ?? "iexClose"
        )
        let week54LowEntity = BarGraphStockEntity(
            color: UIColor.Stocks.week52LowStockColor,
            height: (week52Low ?? 0),
            textValue: String(week52Low ?? 0),
            title: String.Stocks.minWeek52
        )
        let week54HighEntity = BarGraphStockEntity(
            color: UIColor.Stocks.week52HighStockColor,
            height: (week52High ?? 0),
            textValue: String(week52High ?? 0),
            title: String.Stocks.maxWeek52
        )
        maximumPrice = sortedArray.last ?? 0.0
        return [highEntity, lowEntity, iexOpenEntity, iexCloseEntity, week54LowEntity, week54HighEntity]
    }
}
