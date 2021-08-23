//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

enum APIError: Error {
    case data
    case responseFail
    case decodingJSON
}
class MainViewController: UIViewController {
    private var items: [CollectionItem] = []
    private var totalPage: Int = 1
    private var lastPage: Int = 1
    private var viewMode: MarketLayout = MarketLayout.init(type: .list)
    
    var isPaging: Bool = false
    var hasNextPage: Bool = false
    
    let networkHandler = NetworkHandler()
  
    @IBOutlet weak var viewModeSegmented: UISegmentedControl!
    
    @IBOutlet weak var marketCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestItems(at: lastPage)
        marketCollectionView.reloadData()
        viewModeSegmented.addTarget(self, action: #selector(changeViewMode), for: .valueChanged)
    }
    
    @objc func changeViewMode() {
        if viewMode.type == .grid {
            viewMode.type = .list
        } else {
            viewMode.type = .grid
        }
        marketCollectionView.reloadData()
    }
}

extension MainViewController {
    private enum Constraint {
        private enum Inset {
            static let left: CGFloat = 5
            static let right: CGFloat = 5
            static let top: CGFloat = 5
            static let down: CGFloat = 5
        }
        static let itemSpace: CGFloat = 5
        static let lineSpace: CGFloat = 5
        
        static let GridWidthSpacing: CGFloat = itemSpace + Inset.left + Inset.right
        static let GridHeightSpacing: CGFloat = lineSpace + Inset.top + Inset.down
        static let ListWidthSpacing: CGFloat = Inset.left + Inset.right
        static let ListHeightSpacing: CGFloat = Inset.top + Inset.down
    }
    
    func requestItems(at page: Int){
        networkHandler.request(with: .getItemCollection(page: page)) { result in
            switch result {
            case .success(let data):
                guard let model = try? JsonHandler().decodeJSONData(json: data, model: ItemCollection.self) else { return }
                self.items.append(contentsOf: model.items)
                self.totalPage = model.page + 1
                DispatchQueue.main.async {
                    self.marketCollectionView.reloadData()
                }
            default:
                break
            }
        }
    }
}

extension MainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(items.count)
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if viewMode.type == .grid {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemCollectionCell.cellReusableIdentifier, for: indexPath) as? ItemCollectionCell else { fatalError() }
            let item = items[indexPath.item]
            cell.configuration(with: item)
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemListCell.cellReusableIdentifier, for: indexPath) as? ItemListCell else { fatalError() }
            let item = items[indexPath.item]
            cell.configuration(with: item)
            return cell
        }
    }
}

extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if lastPage < totalPage && indexPath.row == items.count - 5 {
            lastPage += 1
            requestItems(at: lastPage)
        }
    }
}

extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let listCellSize = CGSize(width: (collectionView.bounds.size.width - Constraint.ListWidthSpacing), height: ((collectionView.bounds.size.width - Constraint.ListHeightSpacing) / 6) * 1.618)
        let gridCellSize = CGSize(width: (collectionView.bounds.size.width - Constraint.GridWidthSpacing) / 2, height: ((collectionView.bounds.size.width - Constraint.GridHeightSpacing) / 2) * 1.618)
 
        if viewMode.type == .grid {
            return gridCellSize
        } else {
            return listCellSize
        }
    }
    
    struct MarketLayout {
        var type: Mode = .grid
        
        enum Mode {
            case grid
            case list
        }
    }
}
