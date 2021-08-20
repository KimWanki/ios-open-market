//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class MainViewController: UIViewController {
//    private let itemCollection: [ItemCollection]
    let networkHandler = NetworkHandler()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        networkHandler.request(with: OpenMarketAPI.getItem(id: 551)) { data in
            print("")
        }
        
        //        networkHandler.request(with: OpenMarketAPI.getItemCollection(page: 1)) {
        //            print("아이템들을 다가져왔슴둥.")
        //        }
        ////
        //        guard let media = Image(withImage: #imageLiteral(resourceName: "dimsum"), forKey: "images[]") else { return }
        //        networkHandler.request(with: OpenMarketAPI.postItem, form: MultiPartFormData(params: ["title":"루얀 만두", "descriptions": "샬롯 추천 대박 상품!", "price":19060, "stock":999, "discounted_price": 5, "password":12345, "currency":"KRW"], media: [media])) {
        //            print("아이템을 서버에 추가했슴둥.")
        //        }
        
        //
        //        networkHandler.request(with: OpenMarketAPI.patchItem(id: 518), form: MultiPartFormData(params: ["descriptions":"샬롯 추천 대박 상품! 에어 프라이어 180도 10분 진리의 만두, 알구몬 추천", "password":"12345"])) {
        //            print("서버에 있는 아이템을 수정했슴둥")
        //        }
        //
        //        networkHandler.request(with: OpenMarketAPI.deleteItem(id: 550), form: JsonObject(params: ["password":"12345"])) {
        //            print("아이템 삭제")
        //        }
    }
}

extension MainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemCollectionCell.cellIdentifier, for: indexPath) as? ItemCollectionCell else { fatalError() }
        
        //configure
        cell.titleLabel.text = "산체스 만두 꿀맛"
        if indexPath.item % 2 == 1 {
            cell.priceLabel.text = """
            firstline
            secondline
            """
        } else {
            cell.priceLabel.text = "firstline"
        }
        return cell
    }
    
    
}


extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let layout = collectionViewLayout as? UICollectionViewFlowLayout else { return CGSize.zero }
        
        let bounds = collectionView.bounds
        
        var width = bounds.width
        var height = bounds.height
        
        let marginX = layout.sectionInset.left + layout.sectionInset.right
        let marginY = layout.sectionInset.bottom + layout.sectionInset.top
            
        width = (width - ( marginX + layout.minimumInteritemSpacing * 1)) / 2
        height = width * 1.5
//        height = (height - ( marginY + layout.minimumLineSpacing * 2 )) / 3
        
        return CGSize(width: width.rounded(.down), height: height.rounded(.down))
    }
    
}

