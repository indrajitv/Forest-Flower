//
//  APIManager.swift
//  Forest Flower
//
//  Created by Indrajit Chavda on 11/06/23.
//

import Foundation

protocol APIManageable {

    func request<T: Decodable>(with endPoint: EndPoint, for model: T.Type) async throws -> T
}


struct APIManager: APIManageable {

    private let session = URLSessionManager()

    func request<T: Decodable>(with endPoint: EndPoint, for model: T.Type) async throws -> T {

        return try await self.session.request(with: endPoint, for: model.self)
    }
}
