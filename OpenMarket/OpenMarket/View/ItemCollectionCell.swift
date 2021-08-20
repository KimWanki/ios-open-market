//
//  ItemCollectionCell.swift
//  OpenMarket
//
//  Created by WANKI KIM on 2021/08/20.
//

import UIKit

class ItemCollectionCell: UICollectionViewCell {
    static let cellIdentifier = "ItemCollectionCell"
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var stockLabel: UILabel!
    @IBOutlet weak var thumnailImage: UIImageView!
    
    func configure() {
        
    }
}
