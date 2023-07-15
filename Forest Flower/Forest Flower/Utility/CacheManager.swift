//
//  CacheManager.swift
//  Forest Flower
//
//  Created by Indrajit Chavda on 14/06/23.
//

import SwiftUI

class CacheManager {
    static let manager: CacheManager = CacheManager()

    private init() {}

    let cache: NSCache = {
        let cache = NSCache<NSURL, NSData>()
        return cache
    }()

    func getImage(for url: URL) throws -> Image {
        if let data = cache.object(forKey: url as NSURL),
           let uiImage = UIImage(data: data as Data) {
            return Image(uiImage: uiImage)
        }
        throw CustomError.custom(description: "No image found in cache.")
    }

    func getData(for url: URL) throws -> Data {
        if let data = cache.object(forKey: url as NSURL) {
            return data as Data
        }
        throw CustomError.custom(description: "No image found in cache.")
    }

    func addImage(for url: URL, with data: Data) {
        cache.setObject(data as NSData, forKey: url as NSURL)
    }

}
