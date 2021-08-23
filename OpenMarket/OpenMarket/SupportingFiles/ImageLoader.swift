//
//  ImageHandler.swift
//  OpenMarket
//
//  Created by WANKI KIM on 2021/08/22.
//

import UIKit

class ImageLoader {
    private let session: sessionComponent
    
    init(session: sessionComponent){
        self.session = session
    }
    
    func loadImage(from url: String, completionHandler: @escaping (UIImage) -> Void) {
        guard let url = URL(string:url) else { return }
        let request = URLRequest(url: url)
        session.dataTask(with: request) { data, response, error in
            guard error == nil,
                  let data = data else { return }
            guard let thumnailImage = UIImage(data: data) else { return }
                completionHandler(thumnailImage)
        }.resume()
    }
    
    func cancel() {
        session.invalidateAndCancel()
    }
}
