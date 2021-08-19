//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class MainViewController: UIViewController {
    let networkHandler = NetworkHandler(session: URLSession.shared)

    override func viewDidLoad() {
        super.viewDidLoad()

        networkHandler.request(with: OpenMarketAPI.getItem(id: 43)) {
            print("특정 아이디의 아이템들 받아오는데 성공했슴둥.")
        }        
        networkHandler.request(with: OpenMarketAPI.getItemCollection(page: 1)) {
            print("아이템들을 다가져왔슴둥.")
        }
        
        guard let media = Media(withImage: #imageLiteral(resourceName: "dimsum"), forKey: "images[]") else { return }
        
        networkHandler.request(with: OpenMarketAPI.patchItem(id: 518), form: MultiPartFormData(params: ["descriptions":"샬롯 추천 대박 상품! 에어 프라이어 180도 10분 진리의 만두, 알구몬 추천", "password":"12345"])) {
            print("서버에 있는 아이템을 수정했슴둥")
        }
        
        networkHandler.request(with: OpenMarketAPI.deleteItem(id: 518), form: JsonObject(params: ["password":"12345"])) {
            print("아이템 삭제")
        }
    }
}

