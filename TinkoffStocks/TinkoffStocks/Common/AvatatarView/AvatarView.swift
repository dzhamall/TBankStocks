//
//  AvatarView.swift
//  TinkoffStocks
//
//  Created by dzhamall on 31.01.2021.
//

import UIKit

final class AvatarView: UIView {

    enum State {
        case initial
        case progress(percent: CGFloat, hesitation: StockModel.PriceHesitation)
        case ended
    }

    private var circlePath = UIBezierPath()
    private var foregroundLineLayer = CAShapeLayer()
    private var backgroundLineLayer = CAShapeLayer()
    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = UIColor.Stocks.backgroundAvatarView
        return imageView
    }()
    private var state: State = .initial

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    convenience init(state: State) {
        self.init(frame: .zero)
        self.state = state
        setup()
        set(state: state, hesitation: nil)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    // MARK: API functions

    func set(state: State, hesitation: StockModel.PriceHesitation?) {
        self.state = state
        switch state {
        case .initial: setupInitialState()
        case .ended: setupEndedState()
        case .progress(let percent, let hesitation):
            setupProgressState(percent: percent, hesitation: hesitation)
        }
        guard let hesitation = hesitation else { return }
        switch hesitation {
        case .positive:
            backgroundLineLayer.strokeColor = UIColor.Stocks.positivePriceChange.cgColor
        case .negative:
            backgroundLineLayer.strokeColor = UIColor.Stocks.negativePriceChange.cgColor
        case .unchanged:
            backgroundLineLayer.strokeColor = UIColor.Stocks.baseUILabelElementColor.cgColor
        }
    }

    func set(image: UIImage, hesitation: StockModel.PriceHesitation?) {
        iconImageView.image = image
        guard let hesitation = hesitation else { return }
        switch hesitation {
        case .positive:
            backgroundLineLayer.strokeColor = UIColor.Stocks.positivePriceChange.cgColor
        case .negative:
            backgroundLineLayer.strokeColor = UIColor.Stocks.negativePriceChange.cgColor
        case .unchanged:
            backgroundLineLayer.strokeColor = UIColor.Stocks.baseUILabelElementColor.cgColor
        }
    }

    // MARK: Private functions

    private func setupCirclePath() {
        let center = CGPoint(x: frame.width / 2.0, y: frame.height / 2.0)
        let radius = frame.width / 2.0 - 1.0
        let endAngle = CGFloat(2.0 * Double.pi)
        circlePath.addArc(withCenter: center, radius: radius, startAngle: 0.0, endAngle: endAngle, clockwise: true)
        circlePath.close()
    }

    private func setupForegroundLineLayer() {
        foregroundLineLayer.path = circlePath.cgPath
        foregroundLineLayer.fillColor = UIColor.clear.cgColor
        foregroundLineLayer.strokeColor = UIColor.Stocks.positivePriceChange.cgColor
        foregroundLineLayer.lineWidth = 2.0
        foregroundLineLayer.strokeEnd = 0.0
        layer.addSublayer(foregroundLineLayer)
    }

    private func setupBackgroundLineLayer() {
        backgroundLineLayer.path = circlePath.cgPath
        backgroundLineLayer.fillColor = UIColor.clear.cgColor
        backgroundLineLayer.strokeColor = UIColor.Stocks.baseUILabelElementColor.cgColor
        backgroundLineLayer.lineWidth = 2.0
        layer.addSublayer(backgroundLineLayer)
    }

    private func setupView() {
        backgroundColor = .clear
        addSubview(iconImageView)
        iconImageView.layer.masksToBounds = true
        iconImageView.layer.cornerRadius = 15.0
        let selfHeightConstraint =  self.widthAnchor.constraint(equalToConstant: 38)
        let selfWithConstraint = self.heightAnchor.constraint(equalToConstant: 38)
        let centerYConstraint = iconImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        let centerXConstraint = iconImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        let heightConstraint = iconImageView.heightAnchor.constraint(equalToConstant: 30.0)
        let widthConstraint = iconImageView.widthAnchor.constraint(equalToConstant: 30.0)
        NSLayoutConstraint.activate([selfHeightConstraint, selfWithConstraint, centerYConstraint, centerXConstraint, heightConstraint, widthConstraint])
    }

    private func setupInitialState() {
        iconImageView.image = nil
        foregroundLineLayer.isHidden = true
        backgroundLineLayer.isHidden = false
    }

    private func setupEndedState() {
        foregroundLineLayer.isHidden = false
        foregroundLineLayer.strokeEnd = 1.0
    }

    private func setupProgressState(percent: CGFloat, hesitation: StockModel.PriceHesitation?) {
        foregroundLineLayer.isHidden = false
        foregroundLineLayer.strokeEnd = percent
        guard let hesitation = hesitation else { return }
        switch hesitation {
        case .positive:
            backgroundLineLayer.strokeColor = UIColor.Stocks.positivePriceChange.cgColor
        case .negative:
            backgroundLineLayer.strokeColor = UIColor.Stocks.negativePriceChange.cgColor
        case .unchanged:
            backgroundLineLayer.strokeColor = UIColor.Stocks.baseUILabelElementColor.cgColor
        }
    }

    private func setup() {
        autoresizingMask = [.flexibleHeight, .flexibleWidth]
        setupCirclePath()
        setupBackgroundLineLayer()
        setupForegroundLineLayer()
        setupView()
    }
}
