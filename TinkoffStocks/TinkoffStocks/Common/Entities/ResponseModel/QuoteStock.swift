//
//  QuoteStockModel.swift
//  TinkoffStocks
//
//  Created by dzhamall on 30.01.2021.
//

import Foundation

struct QuoteStock: Codable {
    /// Refers to the stock ticker
    let symbol: String?
    /// Refers to the company name
    let companyName: String?
    /// Refers to the change in price between latestPrice and previousClose
    let change: Double?
    /// Refers to the percent change in price between latestPrice and previousClose. 
    let changePercent: Double?
    /// Refers to the market-wide highest price from the SIP. 15 minute delayed during normal market hours 9:30 - 16:00 (null before 9:45 and weekends).
    let high: Float?
    /// Refers to time high was updated as epoch timestamp
    let highTime: Double?
    /// Refers to the market-wide lowest price from the SIP. 15 minute delayed during normal market hours 9:30 - 16:00 (null before 9:45 and weekends).
    let low: Float?
    /// Refers to time low was updated as epoch timestamp
    let lowTime: Double?
    /// Use this to get the latest price
    let latestPrice: Double?
    /// Refers to the open price from IEX
    let iexOpen: Float?
    /// Refers to the listing exchange time for the open from IEX
    let iexOpenTime: Double?
    /// Refers to the close price from IEX
    let iexClose: Float?
    /// Refers to the listing exchange time for the close from IEX
    let iexCloseTime: Double?
    /// Refers to the adjusted 52 week low
    let week52Low: Float?
    /// Refers to the adjusted 52 week high
    let week52High: Float?
}
