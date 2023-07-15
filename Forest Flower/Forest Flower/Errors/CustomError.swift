//
//  CustomError.swift
//  Forest Flower
//
//  Created by Indrajit Chavda on 11/06/23.
//

import Foundation

enum CustomError: Error {

    case somethingWentWrong

    case badRequest
    case unauthorised
    case forbidden
    case notFound

    case custom(description: String)
    case with(error: Error)

    var code: Int {
        switch self {
            case .badRequest:
                return 400
            case .unauthorised:
                return 401
            case .forbidden:
                return 403
            case .notFound:
                return 404
            default:
                return -999
        }
    }

    var desc: String {
        switch self {
            case .badRequest:
                return "The request was unacceptable, often due to missing a required parameter."
            case .unauthorised:
                return "Invalid access token."
            case .forbidden:
                return "Missing permissions to perform request."
            case .notFound:
                return "The requested resource doesn’t exist."
            case .custom(let description):
                return description
            case .with(let error):
                return error.localizedDescription.capitalized
            default:
                return "Oops! Something went wrong."
        }
    }

    init(rawValue: Int) {
        switch rawValue {
            case 400:
                self = .badRequest
            case 401:
                self = .unauthorised
            case 403:
                self = .forbidden
            case 404:
                self = .notFound
            default:
                self = .somethingWentWrong
        }
    }
}
