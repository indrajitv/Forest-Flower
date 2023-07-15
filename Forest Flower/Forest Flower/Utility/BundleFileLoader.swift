//
//  BundleFileLoader.swift
//  Forest Flower
//
//  Created by Indrajit Chavda on 08/07/23.
//

import Foundation

@propertyWrapper
struct BundleFileLoader {

    let name: String
    let type: String

    var bundle: Bundle = .main

    var wrappedValue: Data? {

        guard let path = bundle.path(forResource: name, ofType: type) else { fatalError() }
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else { fatalError() }

        return data
    }
}
