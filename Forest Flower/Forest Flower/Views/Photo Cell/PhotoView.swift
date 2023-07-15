//
//  PhotoView.swift
//  Forest Flower
//
//  Created by Indrajit Chavda on 12/06/23.
//

import SwiftUI

struct PhotoView: View {

    let imageWidth: CGFloat

    @ObservedObject
    private(set) var viewModel: PhotoViewModel

    let showDownloadDetailsAutomaticIfAvailable: Bool
    
    var onDelete: (() -> ())?

    @ViewBuilder
    var image: some View {
        if let loaded = self.viewModel.smallImageCache, let image = UIImage(data: loaded) {
            Image(uiImage: image)
                .resizable()
        } else {
            URLImage(url: self.viewModel.smallPhotoURL,
                     cacheReference: self.$viewModel.smallImageCache) {
                Rectangle()
                    .fill(self.viewModel.backgroundColor)
            } image: { image in
                image.resizable()
            }
        }
    }

    var downloadDetailsFooter: some View {
        VStack {
            Spacer()
            HStack {
                if let downloadedDateString = viewModel.downloadedDateString {
                    HStack {
                        SystemImage.clock
                        Text(downloadedDateString)
                            .setFont(style: .body)
                    }
                    .padding(.leading, 10)
                    Spacer()
                }

                Button {
                    onDelete?()
                } label: {
                    SystemImage.trash
                }
                .padding()
                .setFont(style: .body)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background {
                LinearGradient(colors: [.red, .indigo], startPoint: .leading, endPoint: .trailing)
                    .opacity(0.7)
            }
            .foregroundColor(.white)
        }
    }

    var body: some View {
        ZStack {
            image
                .frame(width: self.viewModel.getImageAspectRation(width: imageWidth).width,
                       height: self.viewModel.getImageAspectRation(width: imageWidth).height)
                .background(viewModel.backgroundColor)
                .scaledToFit()
                .border(.gray, width: 0.2)

            if self.showDownloadDetailsAutomaticIfAvailable, self.viewModel.downloadedDateString != nil {
                self.downloadDetailsFooter
            }
        }
    }
}

