//
//  StocksPresenter.swift
//  TinkoffStocks
//
//  Created by dzhamall on 30.01.2021.
//

import Foundation

final class StocksPresenter {

    private var companies: [String] = []
    weak var view: StocksViewInput?
}

// MARK: - StocksViewOutput
extension StocksPresenter: StocksViewOutput {

    func obtainDataForDisplay(forRow row: Int) -> String? {
        return companies[row]
    }

    func obtainNumberOfRowsInPickerView() -> Int {
        return companies.count
    }
}
