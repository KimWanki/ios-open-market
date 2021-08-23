//
//  ItemCollection.swift
//  OpenMarket
//
//  Created by Luyan, Ellen on 2021/08/10.
//

import UIKit

class CollectionItem: Decodable {
    let id: Int
    let title: String
    let price: Int
    let currency: String
    let stock: Int
    let discountedPrice: Int?
    let thumbnails: [String]
    let registrationDate: Double
}

class ItemCollection: Decodable {
    let page: Int
    let items: [CollectionItem]
}
