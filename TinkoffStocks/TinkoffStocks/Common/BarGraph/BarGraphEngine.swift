//
//  BarGraphEngine.swift
//  TinkoffStocks
//
//  Created by dzhamall on 31.01.2021.
//

import Foundation
import CoreGraphics.CGGeometry

final class BarGraphEngine {

    private let barWidth: CGFloat
    private let space: CGFloat
    private let bottomSpace: CGFloat = 40.0
    private let topSpace: CGFloat = 40.0

    var barGraphStockEntities: [BarGraphStockEntity] = []

    init(barWidth: CGFloat = 40, space: CGFloat = 20) {
        self.barWidth = barWidth
        self.space = space
    }

    var computeContentWidth: CGFloat {
        return (barWidth + space) * CGFloat(barGraphStockEntities.count) + space
    }

    func computeBarEntries(viewHeight: CGFloat, maximumValue: CGFloat) -> [BarGraphEntity] {
        var result: [BarGraphEntity] = []
        for (index, entity) in barGraphStockEntities.enumerated() {
            let entityHeight = computedHeight(
                entityHeight: CGFloat(entity.height),
                viewHeight: viewHeight,
                maximumValue: maximumValue
            )
            let xPosition: CGFloat = space + CGFloat(index) * (barWidth + space)
            let yPosition = viewHeight - bottomSpace - entityHeight
            let origin = CGPoint(x: xPosition, y: yPosition)
            let barEntity = BarGraphEntity(
                origin: origin,
                barWidth: barWidth,
                barHeight: entityHeight,
                space: space,
                stockEntity: entity
            )
            result.append(barEntity)
        }
        return result
    }

    private func computedHeight(entityHeight: CGFloat, viewHeight: CGFloat, maximumValue: CGFloat) -> CGFloat {
        /// Рассчет графика происходит в пределах одной акции
        if maximumValue > viewHeight {
            let differenceSize = maximumValue / (viewHeight - bottomSpace - topSpace)
            return entityHeight / differenceSize
        } else {
            let differenceSize = (viewHeight - bottomSpace - topSpace) / maximumValue
            return entityHeight * differenceSize
        }
    }
}
