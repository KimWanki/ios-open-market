//
//  NetworkHandler.swift
//  OpenMarket
//
//  Created by Luyan, Ellen on 2021/08/17.
//

import Foundation

protocol sessionComponent {
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}

extension URLSession: sessionComponent {}

struct NetworkHandler {
    private let session: sessionComponent
    private let valuableMethod: [HttpMethod]
    
    init(session: sessionComponent = URLSession.shared, valuableMethod: [HttpMethod] = HttpMethod.allCases) {
        self.session = session
        self.valuableMethod = valuableMethod
    }
    
    func request(with http: OpenMarketAPI, form: HttpBody? = nil, completionHandler: @escaping (Result<Data, Error>) -> Void) {
        guard valuableMethod.contains(http.request.type),
              let url = URL(string: http.request.url)
        else { return }
        
        var urlRequest = URLRequest(url: url)
        let contentType = form?.contentType ?? "application/json"
        urlRequest.httpMethod = http.request.type.description
        
        if let httpBody = try? form?.createBody() {
            urlRequest.setValue(contentType, forHTTPHeaderField: "Content-Type")
            urlRequest.httpBody = httpBody
        }
        
        session.dataTask(with: urlRequest) { data, response, error in
            guard let error = error else { return }
            guard let response = response as? HTTPURLResponse,
                  (200...299).contains(response.statusCode) else { return }
            
            
            if let data = data {
                completionHandler(.success(data))
            }
        }.resume()
        
    }
    
    func generateBoundary() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }
}
