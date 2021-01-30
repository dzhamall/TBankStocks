//
//  ViewController.swift
//  TinkoffStocks
//
//  Created by dzhamall on 30.01.2021.
//

import UIKit

final class StocksViewController: UIViewController {

    private lazy var companiesPickerView = UIPickerView()
    private lazy var companyConstantNameLabel = UILabel()
    private lazy var companyNameLabel = UILabel()
    private lazy var symbolConstantLabel = UILabel()
    private lazy var symbolLabel = UILabel()
    private lazy var priceConstantLabel = UILabel()
    private lazy var priceLabel = UILabel()
    private lazy var priceChangeConstantLabel = UILabel()
    private lazy var priceChangeLabel = UILabel()

    private let output: StocksViewOutput

    init(output: StocksViewOutput) {
        self.output = output
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        output.viewIsReady()
        setupViewsConstraints()
    }
}

// MARK: - Stocks View Input
extension StocksViewController: StocksViewInput {

    func displayStocksInfo() {
        guard Thread.isMainThread else { return }
        companiesPickerView.reloadAllComponents()
    }

    func updateStockInfo(withModel model: StockModel) {
        guard Thread.isMainThread else { return }
        companyNameLabel.text = model.companyName
        symbolLabel.text = model.symbol
        priceLabel.text = model.latestPrice
        priceChangeLabel.text = model.changePrice
        switch model.priceHesitation {
        case .positive:
            priceChangeLabel.textColor = UIColor.Stocks.positivePriceChange
        case .negative:
            priceChangeLabel.textColor = UIColor.Stocks.negativePriceChange
        case .unchanged:
            priceChangeLabel.textColor = UIColor.Stocks.baseUILabelElementColor
        }
    }
}

// MARK: - Picker View Data Source
extension StocksViewController: UIPickerViewDataSource {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return output.obtainNumberOfRowsInPickerView()
    }
}

// MARK: - Picker View Delegate
extension StocksViewController: UIPickerViewDelegate {

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return output.obtainDataForDisplay(forRow: row)
    }

    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return pickerView.bounds.height / 5
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        output.pickerView(didSelectRow: row)
    }
}

// MARK: - Constraints
private extension StocksViewController {

    func setupViewsConstraints() {
        let pickerViewConstraints = companiesPickerViewConstraints()
        let nameLabelsConstraints = companyConstantNameLabelConstraints() + companyNameLabelConstraints()
        let symboLabelsConstraints = symbolConstantLabelConstraints() + symbolLabelConstraints()
        let priceLabelsConstraints = priceConstantLabelConstraints() + priceLabelConstraints() + priceChangeLabelConstraints() +
            priceChangeConstantLabelConstraints()
        NSLayoutConstraint.activate(
            pickerViewConstraints + nameLabelsConstraints + symboLabelsConstraints + priceLabelsConstraints
        )
        companyConstantNameLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        companyNameLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        symbolConstantLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        symbolLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        priceConstantLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        priceLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        priceChangeConstantLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        priceChangeLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
    }

    func companiesPickerViewConstraints() -> [NSLayoutConstraint] {
        companiesPickerView.translatesAutoresizingMaskIntoConstraints = false
        companiesPickerView.delegate = self
        companiesPickerView.dataSource = self

        view.addSubview(companiesPickerView)

        let constraints = [
            companiesPickerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            companiesPickerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            companiesPickerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            companiesPickerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3)
        ]
        return constraints
    }

    func companyConstantNameLabelConstraints() -> [NSLayoutConstraint] {
        view.addSubview(companyConstantNameLabel.configure(withText: String.Stocks.companyNameConstantString, textAligment: .left))
        let constraints = [
            companyConstantNameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 22),
            companyConstantNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 22)
        ]
        return constraints
    }

    func companyNameLabelConstraints() -> [NSLayoutConstraint] {
        view.addSubview(companyNameLabel.configure(withText: String.Stocks.forEmptyLabel, textAligment: nil))
        let constraints = [
            companyNameLabel.topAnchor.constraint(equalTo: companyConstantNameLabel.topAnchor),
            companyNameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -22),
            companyNameLabel.leadingAnchor.constraint(
                greaterThanOrEqualTo: companyConstantNameLabel.trailingAnchor,
                constant: 22)
        ]
        return constraints
    }

    func symbolConstantLabelConstraints() -> [NSLayoutConstraint] {
        view.addSubview(symbolConstantLabel.configure(withText: String.Stocks.symbolConstantString, textAligment: .left))
        let constraints = [
            symbolConstantLabel.topAnchor.constraint(equalTo: companyConstantNameLabel.bottomAnchor, constant: 16),
            symbolConstantLabel.leadingAnchor.constraint(equalTo: companyConstantNameLabel.leadingAnchor)
        ]
        return constraints
    }

    func symbolLabelConstraints() -> [NSLayoutConstraint] {
        view.addSubview(symbolLabel.configure(withText: String.Stocks.forEmptyLabel, textAligment: nil))
        let constraints = [
            symbolLabel.topAnchor.constraint(equalTo: symbolConstantLabel.topAnchor),
            symbolLabel.trailingAnchor.constraint(equalTo: companyNameLabel.trailingAnchor),
            symbolLabel.leadingAnchor.constraint(
                greaterThanOrEqualTo: symbolConstantLabel.trailingAnchor,
                constant: 22)
        ]
        return constraints
    }

    func priceConstantLabelConstraints() -> [NSLayoutConstraint] {
        view.addSubview(priceConstantLabel.configure(withText: String.Stocks.priceConstantString, textAligment: .left))
        let constraints = [
            priceConstantLabel.topAnchor.constraint(equalTo: symbolConstantLabel.bottomAnchor, constant: 16),
            priceConstantLabel.leadingAnchor.constraint(equalTo: symbolConstantLabel.leadingAnchor)
        ]
        return constraints
    }

    func priceLabelConstraints() -> [NSLayoutConstraint] {
        view.addSubview(priceLabel.configure(withText: String.Stocks.forEmptyLabel, textAligment: nil))
        let constraints = [
            priceLabel.topAnchor.constraint(equalTo: symbolConstantLabel.bottomAnchor, constant: 16),
            priceLabel.trailingAnchor.constraint(equalTo: symbolLabel.trailingAnchor),
            priceLabel.leadingAnchor.constraint(
                greaterThanOrEqualTo: priceConstantLabel.trailingAnchor,
                constant: 22)
        ]
        return constraints
    }

    func priceChangeConstantLabelConstraints() -> [NSLayoutConstraint] {
        view.addSubview(priceChangeConstantLabel.configure(withText: String.Stocks.priceChangeConstantString, textAligment: .left))
        let constraints = [
            priceChangeConstantLabel.topAnchor.constraint(equalTo: priceConstantLabel.bottomAnchor, constant: 16),
            priceChangeConstantLabel.leadingAnchor.constraint(equalTo: priceConstantLabel.leadingAnchor)
        ]
        return constraints
    }

    func priceChangeLabelConstraints() -> [NSLayoutConstraint] {
        view.addSubview(priceChangeLabel.configure(withText: String.Stocks.forEmptyLabel, textAligment: nil))
        let constraints = [
            priceChangeLabel.topAnchor.constraint(equalTo: priceChangeConstantLabel.topAnchor),
            priceChangeLabel.trailingAnchor.constraint(equalTo: priceLabel.trailingAnchor),
            priceChangeLabel.leadingAnchor.constraint(
                greaterThanOrEqualTo: priceConstantLabel.trailingAnchor,
                constant: 22)
        ]
        return constraints
    }
}
