//
//  BarGraphEntity.swift
//  TinkoffStocks
//
//  Created by dzhamall on 31.01.2021.
//

import Foundation
import CoreGraphics.CGGeometry

struct BarGraphEntity {
    let origin: CGPoint
    let barWidth: CGFloat
    let barHeight: CGFloat
    let space: CGFloat
    let stockEntity: BarGraphStockEntity

    var bottomTitleFrame: CGRect {
        return CGRect(x: origin.x - space/2, y: origin.y + 10 + barHeight, width: barWidth + space, height: 22)
    }

    var textValueFrame: CGRect {
        return CGRect(x: origin.x - space/2, y: origin.y - 30, width: barWidth + space, height: 22)
    }

    var barFrame: CGRect {
        return CGRect(x: origin.x, y: origin.y, width: barWidth, height: barHeight)
    }
}

