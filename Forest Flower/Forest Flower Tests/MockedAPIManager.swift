//
//  MockedAPIManager.swift
//  Forest Flower Tests
//
//  Created by Indrajit Chavda on 08/07/23.
//

import Foundation

@testable import Forest_Flower

class MockedAPIManager<T>: APIManageable {

    var situation: MockedSituation

    init(situation: MockedSituation) {

        self.situation = situation
    }

    func request<T: Decodable>(with endPoint: EndPoint, for model: T.Type) async throws -> T {

        switch situation {
            case .error:
                throw CustomError.badRequest
            case .data(let data):
                return try JSONDecoder().decode(T.self, from: data)
        }
    }

    enum MockedSituation {

        case error
        case data(data: Data)
    }
}
