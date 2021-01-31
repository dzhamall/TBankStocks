//
//  Double+TimeConfigurable.swift
//  TinkoffStocks
//
//  Created by dzhamall on 31.01.2021.
//

import Foundation

extension Double {

    func unixtimeToString() -> String {
        let date = Date(timeIntervalSince1970: self)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM"
        dateFormatter.timeZone = .current
        return dateFormatter.string(from: date)
    }
}

