//
//  SearchPhotos.swift
//  Forest Flower
//
//  Created by Indrajit Chavda on 25/06/23.
//

import Foundation

enum SearchPhotos: EndPoint {

    case search(parameters: SearchPhotosParams)
    case topic(parameters: PhotosParams)

    var endPoint: String {
        switch self {
            case .search:
                return "/search/photos"
            case .topic:
                return "/topics"
        }
    }

    var parameter: Encodable? {
        switch self {
            case .search(let params):
                return params
            case .topic(let params):
                return params
        }
    }

    var method: HTTPMethod {
        switch self {
            case .search, .topic:
                return .GET
        }
    }
}

struct SearchPhotosParams: Encodable {
    var page: Int
    var perPage: Int
    var query: String

    enum CodingKeys: String, CodingKey {
        case page
        case perPage = "per_page"
        case query
    }
}
