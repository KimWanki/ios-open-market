//
//  ItemCollectionCell.swift
//  OpenMarket
//
//  Created by WANKI KIM on 2021/08/20.
//

import UIKit
let imageLoader = ImageLoader(session: URLSession.shared)

class ItemCollectionCell: UICollectionViewCell {
    static let cellReusableIdentifier = "\(ItemCollectionCell.self)"
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var discountPriceLabel: UILabel!
    @IBOutlet weak var stockLabel: UILabel!
    @IBOutlet weak var thumnailImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 20.0
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.gray.cgColor.copy(alpha: 0.6)
        
        self.titleLabel.adjustsFontSizeToFitWidth = true
        self.priceLabel.adjustsFontSizeToFitWidth = true
        self.discountPriceLabel.adjustsFontSizeToFitWidth = true
        self.stockLabel.adjustsFontSizeToFitWidth = true
    }
    
    func configuration(with item: CollectionItem) {
        titleLabel.text = item.title
        if let discountPrice = item.discountedPrice {
            priceLabel.attributedText = "\(item.price) \(item.currency)".strikeThrough()
            discountPriceLabel.text = "\(discountPrice) \(item.currency)"
        } else {
            priceLabel.text = "\(item.price) \(item.currency)"
        }
        stockLabel.text = item.stock > 9_999 ? "잔여수량: 9,999개" : item.stock > 0 ? "잔여수량: \(item.stock)개" : "품절"
        stockLabel.textColor = item.stock <= 0 ? .orange : .black
        if let image = imageCache.image(forKey: String(item.id)) {
            DispatchQueue.main.async {
                self.thumnailImage.image = image
            }
        } else {
            item.thumbnails.first.flatMap({
                imageLoader.loadImage(from: $0){ image in
                    imageCache.add(image, forKey: String(item.id))
                    DispatchQueue.main.async {
                        self.thumnailImage.image = image
                    }
                }
            })
        }
    }
    
    override func prepareForReuse() {
        imageLoader.cancel()
        self.titleLabel.text = nil
        self.priceLabel.attributedText = nil
        self.priceLabel.text = nil
        self.discountPriceLabel.text = nil
        self.thumnailImage.image = nil
        self.stockLabel.text = nil
        self.stockLabel.textColor = nil
    }
}

// KingFisher
// 이미지 로더에 url을 넣으면 자동으로 UIImage가 나오도록 함.
// 뭔가 이미지 파일을 다운로드 받으면, 다운로드 시간이 걸린다.
// 그 사이에 재사용이 되어버릴 경우, scroll을 해버릴 경우, 안보여줘도 되는 경우가 
