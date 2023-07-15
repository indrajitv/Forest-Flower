//
//  FetchPhotos.swift
//  Forest Flower
//
//  Created by Indrajit Chavda on 11/06/23.
//

import Foundation

enum FetchPhotos: EndPoint {

    case getHomeFeed(parameters: PhotosParams?)

    var endPoint: String {

        switch self {
            case .getHomeFeed:
                return "/photos"
        }
    }

    var parameter: Encodable? {
        switch self {
            case .getHomeFeed(let params):
                return params
        }
    }

    var method: HTTPMethod {
        switch self {
            case .getHomeFeed:
                return .GET
        }
    }
}

struct PhotosParams: Encodable {

    var page: Int
    var perPage: Int
    var orderBy: Order

    enum CodingKeys: String, CodingKey {
        case page
        case perPage = "per_page"
        case orderBy = "order_by"
    }

    enum Order: String, Encodable {
        case latest
        case oldest
        case popular
    }
}
