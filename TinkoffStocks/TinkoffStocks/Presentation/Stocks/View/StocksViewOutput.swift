//
//  StocksViewOutput.swift
//  TinkoffStocks
//
//  Created by dzhamall on 30.01.2021.
//

import Foundation

protocol StocksViewOutput {

    func viewIsReady()
    func obtainDataForDisplay(forRow row: Int) -> String?
    func obtainNumberOfRowsInPickerView() -> Int
    func pickerView(didSelectRow row: Int)
}
