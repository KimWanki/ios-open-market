//
//  MockSession.swift
//  OpenMarketTests
//
//  Created by Luyan on 2021/08/19.
//
@testable import OpenMarket
import Foundation

class MockSession: sessionComponent {
    private let isSuccess: Bool
    
    init(isSuccess: Bool) {
        self.isSuccess = isSuccess
    }
    
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        if isSuccess {
            
        } else {
            
        }
        
        return URLSessionDataTask()
    }
}
