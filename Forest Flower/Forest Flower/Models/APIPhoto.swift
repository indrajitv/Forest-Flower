//
//  PhotoModel.swift
//  Forest Flower
//
//  Created by Indrajit Chavda on 11/06/23.
//

import Foundation

struct APIPhoto: Codable {

    let id: String

    let width, height: Double

    let color, blur_hash: String?

    let description, alt_description: String?

    let urls: APIPhotoURLs

    let links: APIPhotoLinks

    let user: APIUser

}

struct APIPhotoURLs: Codable {

    let raw, full, regular, small, thumb: URL
}

struct APIPhotoLinks: Codable {

    let download, download_location: URL
}

struct APIUser: Codable {
    let id: String
    let username: String
    let name: String
    let location: String?
    var bio: String?
    var profile_image: APIProfileImage?
    var social: APISocial?
}

struct APIProfileImage: Codable {

    var large: URL?
}

struct APISocial: Codable {

    var insta, twitter: String?

    enum CodingKeys: String, CodingKey {

        case insta = "instagram_username"
        case twitter = "twitter_username"
    }
}
