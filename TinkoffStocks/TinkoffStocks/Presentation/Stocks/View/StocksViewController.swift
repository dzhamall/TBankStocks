//
//  ViewController.swift
//  TinkoffStocks
//
//  Created by dzhamall on 30.01.2021.
//

import UIKit

final class StocksViewController: UIViewController {

    // MARK: - Property
    private lazy var companiesPickerView = UIPickerView()
    private lazy var companyConstantNameLabel = UILabel()
    private lazy var companyNameLabel = UILabel()
    private lazy var symbolConstantLabel = UILabel()
    private lazy var symbolLabel = UILabel()
    private lazy var priceConstantLabel = UILabel()
    private lazy var priceLabel = UILabel()
    private lazy var priceChangeConstantLabel = UILabel()
    private lazy var priceChangeLabel = UILabel()
    private lazy var activityIndicator = UIActivityIndicatorView(style: .gray)
    private lazy var barGraphView = BarGraph()

    private lazy var avatarLogoView: AvatarView = {
        let avatarView = AvatarView(frame: CGRect(x: 0.0, y: 0.0, width: 38.0, height: 38.0))
        avatarView.set(state: .initial, hesitation: nil)
        return avatarView
    }()
    private lazy var avatarBarItem: UIBarButtonItem = {
        let item = UIBarButtonItem(customView: avatarLogoView)
        item.width = 38.0
        return item
    }()
    private lazy var stockLogoBarItem: UIBarButtonItem = {
        let item = UIBarButtonItem(
            title: String.Stocks.stockAppTitleString,
            style: .plain,
            target: nil,
            action: nil
        )
        item.tintColor = UIColor.Stocks.baseUILabelElementColor
        return item
    }()
    private lazy var blurView: UIVisualEffectView = {
        let view = UIVisualEffectView()
        view.effect = UIBlurEffect(style: .dark)
        view.alpha = 0
        view.isUserInteractionEnabled = false
        view.frame = self.view.bounds
        return view
    }()

    private let output: StocksViewOutput

    // MARK: - Lyfecycle

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
        setupNavigationBar()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    // MARK: - Private Methods

    private func toggleBlur(_ blurred: Bool) {
        self.blurView.alpha = blurred ? 0.99 : 0
    }
}

// MARK: - Stocks View Input
extension StocksViewController: StocksViewInput {

    func displayStocksInfo() {
        guard Thread.isMainThread else { return }
        companiesPickerView.reloadAllComponents()
    }

    func startActivityIndicator() {
        activityIndicator.startAnimating()
    }

    func stopActivityIndicator() {
        activityIndicator.stopAnimating()
    }

    func display(logo: UIImage, model: StockModel) {
        avatarLogoView.set(image: logo, hesitation: model.priceHesitation)
    }

    func dropInfos() {
        avatarLogoView.set(state: .initial, hesitation: .unchanged)
        companyNameLabel.text = String.Stocks.forEmptyLabel
        symbolLabel.text = String.Stocks.forEmptyLabel
        priceLabel.text = String.Stocks.forEmptyLabel
        priceChangeLabel.text = String.Stocks.forEmptyLabel
        priceChangeLabel.textColor = UIColor.Stocks.baseUILabelElementColor
    }

    func updateStockInfo(withModel model: StockModel, initialIndex: Int? = nil) {
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
        barGraphView.updateDataEntities(
            entity: model.configureBarGraphStockEntity(),
            animated: true,
            maximumValue: model.maximumPrice
        )
        guard let initialIndex = initialIndex else { return }
        companiesPickerView.selectRow(initialIndex, inComponent: initialIndex, animated: true)

    }

    func show(error: NetworkError) {
        toggleBlur(true)
        let alertAction = UIAlertAction(title: "Попробовать еще раз", style: .cancel) { action in
            self.output.viewIsReady()
            self.toggleBlur(false)
        }
        AlertService.showAlert(
            style: .actionSheet,
            title: "Извините, что то пошло не так",
            message: error.localizedDescription,
            actions: [alertAction],
            completion: nil)
    }

    func showReachabilityError() {
        toggleBlur(true)
        avatarLogoView.set(state: .initial, hesitation: .unchanged)
        let alertAction = UIAlertAction(title: " Обновить ", style: .cancel) { action in
            self.output.viewIsReady()
            self.toggleBlur(false)
        }
        AlertService.showAlert(
            style: .actionSheet,
            title: "УУУпс... похоже нет доступа к интернету. Попробуйте проверить интернет соединение или разрешение на сотовые данные в настройках",
            actions: [alertAction]
        )
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
        let barGraphViewsConstraints = barGraphViewConstraints() + activityIdicatorConstraints()
        NSLayoutConstraint.activate(
            pickerViewConstraints + nameLabelsConstraints + symboLabelsConstraints + priceLabelsConstraints +
                barGraphViewsConstraints
        )
        view.addSubview(blurView)
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
        companyNameLabel.minimumScaleFactor = 0.75
        companyNameLabel.adjustsFontSizeToFitWidth = true
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

    func barGraphViewConstraints() -> [NSLayoutConstraint] {
        barGraphView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(barGraphView)
        let constraints = [
            barGraphView.topAnchor.constraint(equalTo: priceChangeConstantLabel.bottomAnchor, constant: 16),
            barGraphView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            barGraphView.trailingAnchor.constraint(equalTo:  view.trailingAnchor),
            barGraphView.bottomAnchor.constraint(equalTo: companiesPickerView.topAnchor, constant: -8)
        ]
        return constraints
    }

    func activityIdicatorConstraints() -> [NSLayoutConstraint] {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
        barGraphView.addSubview(activityIndicator)
        let constraints = [
            activityIndicator.centerYAnchor.constraint(equalTo: barGraphView.centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: barGraphView.centerXAnchor)
        ]
        return constraints
    }

    func setupNavigationBar() {
        UIView.performWithoutAnimation {
            self.navigationItem.leftBarButtonItem = stockLogoBarItem
            let space1 = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
            space1.width = 8.0
            self.navigationItem.rightBarButtonItems = [avatarBarItem, space1]
        }
    }
}
