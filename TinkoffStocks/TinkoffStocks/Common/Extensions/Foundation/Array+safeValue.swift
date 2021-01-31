//
//  Array+safeValue.swift
//  TinkoffStocks
//
//  Created by dzhamall on 31.01.2021.
//

import Foundation

extension Array {
    func safeValue(at index: Int) -> Element? {
        if index < self.count {
            return self[index]
        } else {
            return nil
        }
    }
}
