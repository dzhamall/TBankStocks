//
//  StocksViewOutput.swift
//  TinkoffStocks
//
//  Created by dzhamall on 30.01.2021.
//

import Foundation

protocol StocksViewOutput {

    func obtainDataForDisplay(forRow row: Int) -> String?
    func obtainNumberOfRowsInPickerView() -> Int
}
