//
//  Data+Extension.swift
//  OpenMarket
//
//  Created by Luyan on 2021/08/17.
//

import Foundation

extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            self.append(data)
        }
    }
}
