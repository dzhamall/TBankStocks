//
//  String+Stocks.swift
//  TinkoffStocks
//
//  Created by dzhamall on 30.01.2021.
//

import Foundation

extension String {

    enum Stocks {

        static var stockAppTitleString: String {
            return "STOCKS"
        }

        static var companyNameConstantString: String {
            return " Company name "
        }

        static var forEmptyLabel: String {
            return "_"
        }

        static var symbolConstantString: String {
            return " Symbol "
        }

        static var priceConstantString: String {
            return " Price "
        }

        static var priceChangeConstantString: String {
            return " Price change "
        }

        static var missingStringValue: String {
            return "Отсутствует"
        }

        static var missingDoubleValue: String {
            return "0.0"
        }

        static var minWeek52: String {
            return "min"
        }

        static var maxWeek52: String {
            return "max"
        }
    }
}
