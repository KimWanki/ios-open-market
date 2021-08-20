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
    func createBody() throws -> Data
}

enum HttpBodyError: Error {
    case NotFoundData
    case NoBoundaryInformation
}

// MARK:- MultiPartFormData
struct MultiPartFormData: HttpBody {
    private let params: [String: Any]?
    private let images: [Image]?
    private let boundary: String = "Boundary-\(NSUUID().uuidString)"
    
    var contentType: String {
        return "multipart/form-data; boundary:\(boundary)"
    }
    
    init(params: [String: Any], media: [Image]? = nil) {
        self.params = params
        self.images = media
    }
    
    func createBody() throws -> Data {
        let lineBreak = "\r\n"
        var body = Data()
        
        if let parameters = params {
            for (key, value) in parameters {
                body.append("--\(boundary + lineBreak)")
                body.append("Content-Disposition: form-data; name=\"\(key)\"\(lineBreak + lineBreak)")
                body.append("\(value)\(lineBreak)")
            }
        }
        
        if let media = images {
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
    var contentType: String = "application/json"
    
    private let params: [String: Any]
    
    init(params: Parameters) {
        self.params = params
    }
    
    func createBody() throws -> Data {
        guard let data = try? JSONSerialization.data(withJSONObject: params, options: []) else { throw HttpBodyError.NotFoundData }
        return data
    }
}
