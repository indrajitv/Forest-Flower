//
//  EndPoint.swift
//  Forest Flower
//
//  Created by Indrajit Chavda on 11/06/23.
//

import Foundation

typealias Headers = [String: String]

protocol EndPoint {

    var mainPoint: String { get }
    var endPoint: String { get }
    var address: URL { get }

    var method: HTTPMethod { get }
    var parameter: Encodable? { get }
    var headers: Headers? { get }

    var timeOut: TimeInterval { get }
}

extension EndPoint {

    var mainPoint: String {
        "https://api.unsplash.com"
    }
    
    var address: URL {
        URL(string: self.mainPoint + self.endPoint)!
    }

    var timeOut: TimeInterval { 30 }

    var headers: Headers? {
        self.getDefaultHeaders()
    }

    func getDefaultHeaders() -> Headers {
        ["Accept-Version": "v1",
         "Authorization": "Client-ID \(APIKeys.apiAccessKey)"]
    }
}
