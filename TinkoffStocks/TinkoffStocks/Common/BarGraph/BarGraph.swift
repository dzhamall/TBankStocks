//
//  BarGraph.swift
//  TinkoffStocks
//
//  Created by dzhamall on 31.01.2021.
//

import UIKit

final class BarGraph: UIView {

    private let mainLayer = CALayer()
    private let scrollView = UIScrollView()

    private var animated = false
    private var maximumValue: Float = 0.0

    private let barGraphEngine = BarGraphEngine(barWidth: 40, space: 35)
    private var barEntities: [BarGraphEntity] = [] {
        didSet {
            mainLayer.sublayers?.forEach { $0.removeFromSuperlayer() }
            scrollView.contentSize = CGSize(
                width: barGraphEngine.computeContentWidth,
                height: self.frame.size.height
            )
            mainLayer.frame = CGRect(x: 0, y: 0, width: scrollView.contentSize.width, height: scrollView.contentSize.height)
            for (index, entity) in barEntities.enumerated() {
                show(entity: entity, index: index, animated: animated, oldEntity: oldValue.safeValue(at: index))
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.updateDataEntities(entity: barGraphEngine.barGraphStockEntities, animated: false, maximumValue: maximumValue)
    }

    func updateDataEntities(entity: [BarGraphStockEntity], animated: Bool, maximumValue: Float) {
        self.animated = animated
        self.maximumValue = maximumValue
        barGraphEngine.barGraphStockEntities = entity
        barEntities = barGraphEngine.computeBarEntries(viewHeight: self.frame.height, maximumValue: CGFloat(maximumValue))
    }

    private func show(entity: BarGraphEntity, index: Int, animated: Bool, oldEntity: BarGraphEntity?) {
        let cgColor = entity.stockEntity.color.cgColor
        mainLayer.addRectangleLayer(
            frame: entity.barFrame,
            color: cgColor,
            animated: animated,
            oldFrame: oldEntity?.barFrame
        )
        mainLayer.addTextLayer(
            frame: entity.textValueFrame,
            color: cgColor,
            fontSize: 14,
            text: entity.stockEntity.textValue,
            animated: animated,
            oldFrame: oldEntity?.textValueFrame
        )
        mainLayer.addTextLayer(
            frame: entity.bottomTitleFrame,
            color: cgColor,
            fontSize: 14,
            text: entity.stockEntity.title,
            animated: animated,
            oldFrame: oldEntity?.bottomTitleFrame)
    }
}

// MARK: - Constraints
private extension BarGraph {

    func setupView() {
        scrollView.layer.addSublayer(mainLayer)
        scrollView.showsHorizontalScrollIndicator = false

        addSubview(scrollView)

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
}
