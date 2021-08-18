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
    
    init(session: sessionComponent) {
        self.session = session
    }
    
    func request(with http: HttpInfo, form: HttpBody? = nil, completionHandler: @escaping () -> Void) {
        guard let url = URL(string: http.Info.url) else { return }
        var urlRequest = URLRequest(url: url)
        
        let contentType = form?.contentType ?? "application/json"
        urlRequest.httpMethod = http.Info.type.description
        
        if let httpBody = form?.createBody() {
            if let boundary = form?.boundary {
                urlRequest.setValue(contentType + "; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            } else {
                urlRequest.setValue(contentType, forHTTPHeaderField: "Content-Type")
            }
            urlRequest.httpBody = httpBody
        }
        
        session.dataTask(with: urlRequest) { data, response, error in
            if let response = response {
                print(response)
            }
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    print(json)
                } catch {
                    print(error)
                }
            }
        }.resume()
        completionHandler()
    }
    
    func generateBoundary() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }
}
