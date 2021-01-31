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
            return UIColor.white
        }

        static var baseUILabelElementColor: UIColor {
            return .black
        }

        static var positivePriceChange: UIColor {
            return UIColor.systemGreen
        }

        static var negativePriceChange: UIColor {
            return UIColor.systemRed
        }

        static var iexOpenStockColor: UIColor {
            return #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
        }

        static var iexCloseStockColor: UIColor {
            return #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
        }

        static var week52LowStockColor: UIColor {
            return #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        }

        static var week52HighStockColor: UIColor {
            return #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        }

        static var backgroundAvatarView: UIColor {
            return #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        }

        static var backgroundLabelConstantView: UIColor {
            return #colorLiteral(red: 0.8420054728, green: 0.8420054728, blue: 0.8420054728, alpha: 1)
        }
    }
}
