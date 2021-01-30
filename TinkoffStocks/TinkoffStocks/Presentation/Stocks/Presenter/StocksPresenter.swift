//
//  StocksPresenter.swift
//  TinkoffStocks
//
//  Created by dzhamall on 30.01.2021.
//

import Foundation

final class StocksPresenter {

    weak var view: StocksViewInput?

    private let networkService: NetworkService
    private let initialSelectedIndex = 0
    private var companies: [StockModel] = []

    init(networkService: NetworkService) {
        self.networkService = networkService
    }

    // MARK: - Private methods

    private func obtainMarketList() {
        networkService.request(endpoint: MarketListEndpoint.configureEndpoint) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let model):
                self.companies = model?.map({ StockModel(responseMarketModel: $0) }) ?? []
                DispatchQueue.main.async {
                    self.view?.displayStocksInfo()
                    self.view?.updateStockInfo(withModel: self.companies[self.initialSelectedIndex])
                }
                DispatchQueue.global(qos: .userInteractive).async {
                    self.obtainQuoteStock(by: self.companies[self.initialSelectedIndex].symbol, for: self.initialSelectedIndex)
                }
            case .failure(let error):
                fatalError()
            }
        }
    }

    private func obtainQuoteStock(by symbol: String, for row: Int) {
        networkService.request(endpoint: QuoteStockEndpoint.configureEndpoint(symbol: symbol)) { [weak self, row] result in
            guard let self = self else { return }
            switch result {
            case .success(let model):
                guard let finalModel = model.map({ StockModel(responseMarketModel: $0)}) else { return }
                self.companies[row] = finalModel
                DispatchQueue.main.async {
                    self.view?.updateStockInfo(withModel: self.companies[row])
                }
            case .failure(let error):
                fatalError()
            }
        }
    }
}

// MARK: - StocksViewOutput
extension StocksPresenter: StocksViewOutput {

    func viewIsReady() {
        DispatchQueue.global(qos: .userInteractive).async {
            self.obtainMarketList()
        }
    }

    func obtainDataForDisplay(forRow row: Int) -> String? {
        return companies[row].companyName
    }

    func obtainNumberOfRowsInPickerView() -> Int {
        return companies.count
    }

    func pickerView(didSelectRow row: Int) {
        view?.updateStockInfo(withModel: companies[row])
        DispatchQueue.global(qos: .userInteractive).async {
            self.obtainQuoteStock(by: self.companies[row].symbol, for: row)
        }
    }
}
