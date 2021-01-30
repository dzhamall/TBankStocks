//
//  UILabel+Configure.swift
//  TinkoffStocks
//
//  Created by dzhamall on 30.01.2021.
//

import UIKit

extension UILabel {
    func configure(withText text: String, textAligment: NSTextAlignment?) -> UIView {
        translatesAutoresizingMaskIntoConstraints = false
        self.text = text

        guard let textAligment = textAligment else { return self }
        textAlignment = textAligment
        return self
    }
}
