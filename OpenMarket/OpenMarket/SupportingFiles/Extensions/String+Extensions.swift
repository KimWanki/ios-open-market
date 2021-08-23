//
//  String+Extensions.swift
//  OpenMarket
//
//  Created by WANKI KIM on 2021/08/22.
//

import UIKit

extension String {
    func strikeThrough() -> NSAttributedString {
        let attributeString = NSMutableAttributedString(string: self)
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: NSMakeRange(0,attributeString.length))
        attributeString.addAttribute(.foregroundColor, value: UIColor.red, range: NSMakeRange(0, attributeString.length))
        return attributeString
    }
}


