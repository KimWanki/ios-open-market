//
//  HttpMethod.swift
//  OpenMarket
//
//  Created by Luyan on 2021/08/19.
//

import Foundation

enum HttpMethod: String, CustomStringConvertible, CaseIterable {
    case get    = "GET"
    case post   = "POST"
    case patch  = "PATCH"
    case delete = "DELETE"
    
    var description: String {
        return self.rawValue
    }
}
