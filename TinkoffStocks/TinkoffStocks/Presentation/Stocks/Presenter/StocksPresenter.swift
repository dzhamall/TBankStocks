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
    private let anyImageLoader: ImageLoader
    private let initialSelectedIndex = 0
    private var currentSelectedRow = 0
    private var companies: [StockModel] = []

    init(networkService: NetworkService, anyImageLoader: ImageLoader) {
        self.networkService = networkService
        self.anyImageLoader = anyImageLoader
    }

    // MARK: - Private methods

    private func obtainMarketList() {
        currentSelectedRow = initialSelectedIndex
        guard Reachability.isConnectedToNetwork() == true else {
            DispatchQueue.main.async {
                self.view?.showReachabilityError()
            }
            return
        }
        networkService.request(endpoint: MarketListEndpoint.configureEndpoint) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let model):
                self.companies = model?.map({ StockModel(responseMarketModel: $0) }) ?? []
                DispatchQueue.main.async {
                    self.view?.stopActivityIndicator()
                    self.view?.displayStocksInfo()
                    self.view?.updateStockInfo(withModel: self.companies[self.initialSelectedIndex],
                                               initialIndex: self.initialSelectedIndex)
                }
                DispatchQueue.global(qos: .userInteractive).async {
                    self.obtainQuoteStock(by: self.companies[self.initialSelectedIndex].symbol, for: self.initialSelectedIndex)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.view?.show(error: error)
                }
            }
        }
    }

    private func obtainQuoteStock(by symbol: String, for row: Int) {
        guard Reachability.isConnectedToNetwork() == true else {
            DispatchQueue.main.async {
                self.view?.showReachabilityError()
            }
            return
        }
        obtainStockLogoURL(by: symbol)
        networkService.request(endpoint: QuoteStockEndpoint.configureEndpoint(symbol: symbol)) { [weak self, row] result in
            guard let self = self else { return }
            switch result {
            case .success(let model):
                guard let finalModel = model.map({ StockModel(responseMarketModel: $0)}) else { return }
                self.companies[row] = finalModel
                DispatchQueue.main.async {
                    self.view?.updateStockInfo(withModel: self.companies[row], initialIndex: nil)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.view?.show(error: error)
                }
            }
        }
    }

    private func obtainStockLogoURL(by symbol: String) {
        networkService.request(endpoint: StockLogoEndpoint.configureEndpoint(symbol: symbol)) { [weak self] result in
            switch result {
            case .success(let model):
                self?.obtainStockLogo(by: model?.url)
            case .failure:
                break
            }
        }
    }

    private func obtainStockLogo(by url: String?) {
        anyImageLoader.load(
            imageId: UUID.init(),
            url: URL(string: url ?? ""),
            progress: nil)
        { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let image):
                DispatchQueue.main.async {
                    self.view?.display(logo: image, model: self.companies[self.currentSelectedRow])
                }
            default:
                break
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
        view?.startActivityIndicator()
    }

    func obtainDataForDisplay(forRow row: Int) -> String? {
        return companies[row].companyName
    }

    func obtainNumberOfRowsInPickerView() -> Int {
        return companies.count
    }

    func pickerView(didSelectRow row: Int) {
        view?.dropInfos()
        currentSelectedRow = row
        guard let model = companies.safeValue(at: row) else { return }
        view?.updateStockInfo(withModel: model, initialIndex: nil)
        DispatchQueue.global(qos: .userInteractive).async {
            self.obtainQuoteStock(by: self.companies[row].symbol, for: row)
        }
    }
}
