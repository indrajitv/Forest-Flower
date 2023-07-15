//
//  SessionProvider.swift
//  Forest Flower
//
//  Created by Indrajit Chavda on 11/06/23.
//

import Foundation

struct URLSessionManager {

    var validHTTPStatusCode: ClosedRange<Int> { (200...299) }

    let session: URLSession = URLSession.init(configuration: .default)

    func request<T: Decodable>(with endPoint: EndPoint, for model: T.Type) async throws -> T {

        let request = self.createURLRequest(from: endPoint)
        let response = try await session.data(for: request)
        let urlResponse = response.1

        if let httpResponse = urlResponse as? HTTPURLResponse {

            if self.validHTTPStatusCode.contains(httpResponse.statusCode) {

                let data = response.0
                print(request.url?.absoluteString ?? "")
                print(String(data: data, encoding: .utf8)!)
                let decoded = try APIDataCoding.decode(from: data, for: model.self)
                return decoded
            } else {

                throw CustomError(rawValue: httpResponse.statusCode)
            }
        } else {

            throw CustomError.somethingWentWrong
        }
    }

    func createURLRequest(from endPoint: EndPoint) -> URLRequest {
        var request = URLRequest(url: endPoint.address)
        request.timeoutInterval = endPoint.timeOut
        request.httpMethod = endPoint.method.rawValue
        request.allHTTPHeaderFields = endPoint.headers

        if ProcessInfo.processInfo.environment["SIMULATOR_DEVICE_NAME"] != nil {
            request.cachePolicy = .returnCacheDataElseLoad
        }

        if let params = endPoint.parameter {
            do {
                try APIDataCoding.encode(parameters: params, for: &request)
            } catch {
                assertionFailure("\(error)")
            }
        }
        
        return request
    }
}
