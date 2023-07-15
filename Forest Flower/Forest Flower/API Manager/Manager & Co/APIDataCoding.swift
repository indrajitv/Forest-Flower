//
//  APIDataCoding.swift
//  Forest Flower
//
//  Created by Indrajit Chavda on 11/06/23.
//

import Foundation

struct APIDataCoding {

    static func decode<T: Decodable>(from data: Data, for model: T.Type) throws -> T {

        let jsonDecoder = JSONDecoder()
        return try jsonDecoder.decode(model.self, from: data)
    }

    static func encode(parameters params: Encodable, for request: inout URLRequest) throws {

        guard let url = request.url else {
            let errorDesc: String = "Expected URL address in URLRequest."
            assertionFailure(errorDesc)
            throw CustomError.custom(description: errorDesc)
        }

        let encodedData = try JSONEncoder().encode(params)
        if HTTPMethod.init(rawValue: request.httpMethod ?? "") == .GET {

            if let jsonParams = try JSONSerialization.jsonObject(with: encodedData) as? [String: Any] {

                var components = URLComponents(string: url.absoluteString)
                components?.queryItems = jsonParams.compactMap{ URLQueryItem(name: $0, value: "\($1)") }
                request.url = components?.url
            }
        } else {
            request.httpBody = encodedData
        }
    }
}
