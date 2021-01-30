//
//  UIColor+Stocks.swift
//  TinkoffStocks
//
//  Created by dzhamall on 30.01.2021.
//

import UIKit.UIColor

extension UIColor {

    enum Stocks {

        static var rootControllerBackground: UIColor {
            if #available(iOS 13.0, *) {
                return UIColor.systemBackground
            } else {
                return UIColor.white
            }
        }
    }
}
