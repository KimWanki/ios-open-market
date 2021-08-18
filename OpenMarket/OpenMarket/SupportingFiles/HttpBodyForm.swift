//
//  HttpBody.swift
//  OpenMarket
//
//  Created by Luyan on 2021/08/17.
//

import Foundation

typealias Parameters = [String: Any]

protocol HttpBody {
    var contentType: String { get }
    var boundary: String? { get }
    func createBody() -> Data
}

// MARK:- MultiPartFormData
struct MultiPartFormData: HttpBody {
    private let params: [String: Any]?
    private let media: [Media]?
    
    var contentType: String = "multipart/form-data"
    var boundary: String? = "Boundary-\(NSUUID().uuidString)"
    
    init(params: [String: Any], media: [Media]? = nil) {
        self.params = params
        self.media = media
    }
    
    func createBody() -> Data {
        let lineBreak = "\r\n"
        var body = Data()
        guard let boundary = boundary else { return Data() }
        
        if let parameters = params {
            for (key, value) in parameters {
                body.append("--\(boundary + lineBreak)")
                body.append("Content-Disposition: form-data; name=\"\(key)\"\(lineBreak + lineBreak)")
                body.append("\(value)\(lineBreak)")
            }
        }
        
        if let media = media {
            for photo in media {
                body.append("--\(boundary + lineBreak)")
                body.append("Content-Disposition: form-data; name=\"\(photo.key)\"; filename=\"\(photo.filename)\"\(lineBreak)")
                body.append("Content-Type: \(photo.mimeType + lineBreak + lineBreak)")
                body.append(photo.data)
                body.append(lineBreak)
            }
        }
            
        body.append("--\(boundary)--\(lineBreak)")
        
        print(String(decoding: body, as: UTF8.self))
        return body
    }
}

// MARK:- JsonObject
struct JsonObject: HttpBody {
    var boundary: String?
    var contentType: String = "application/json"
    
    private let params: [String: Any]
    
    init(params: Parameters) {
        self.params = params
    }
    
    func createBody() -> Data {
        params
        return Data()
    }
}
