//
//  URLImage.swift
//  Forest Flower
//
//  Created by Indrajit Chavda on 14/06/23.
//

import SwiftUI

struct URLImage<Placeholder: View, Content: View>: View {

    @Binding
    private var cacheReference: Data?

    @State
    private var imageData: Data? {
        didSet {
            self.cacheReference = self.imageData
        }
    }

    @StateObject var remoteImageLoader: URLImageLoader

    @ViewBuilder
    var contentView: some View {
        if let imageData = self.imageData, let uiImage = UIImage(data: imageData) {
            self.image(.init(uiImage: uiImage))
        } else {
            self.placeholder()
        }
    }

    private let placeholder: () -> Placeholder
    
    private let image: (_ image: Image) -> Content

    init(url: URL,
         cacheReference: Binding<Data?>,
         @ViewBuilder placeholder: @escaping () -> Placeholder,
         @ViewBuilder image: @escaping (_ image: Image) -> Content) {

        self._cacheReference = cacheReference
        self._remoteImageLoader = StateObject(wrappedValue: URLImageLoader(url: url))
        self.placeholder = placeholder
        self.image = image
    }

    var body: some View {
        contentView.onReceive(self.remoteImageLoader.$data) { data in
            self.imageData = data
        }
    }
}

extension URLImage {
    
    @MainActor
    class URLImageLoader: ObservableObject {

        @Published
        var data: Data?

        init(url: URL) {
            Task {
                do {
                    let response = try await URLSession.shared.data(for: .init(url: url))
                    self.data = response.0
                } catch {
                    data = nil
                }
            }
        }
    }
}
