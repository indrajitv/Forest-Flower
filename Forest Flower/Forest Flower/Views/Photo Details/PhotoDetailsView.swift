//
//  PhotoDetailsView.swift
//  Forest Flower
//
//  Created by Indrajit Chavda on 12/06/23.
//

import SwiftUI

struct PhotoDetailsView: View {

    @ObservedObject
    var viewModel: PhotoViewModel

    var onChange: (() -> ())?

    var header: some View {
        PhotoDetailsHeaderView(viewModel: viewModel)
    }

    @ViewBuilder
    var urlImage: some View {
        if let loaded = self.viewModel.smallImageCache, let image = UIImage(data: loaded) {
            Image(uiImage: image)
        } else {
            // This should not happen as we are already downloading in home screen.
            URLImage(url: viewModel.smallPhotoURL, cacheReference: $viewModel.smallImageCache) {
                self.viewModel.blurImage?.resizable()
            } image: { image in
                image.resizable()
            }
        }
    }

    var detailsView: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                SystemImage.locationSquare
                Text(self.viewModel.userLocation)
            }
            .foregroundColor(.white)
            .padding(.top, 5)
            .setFont(style: .small)

            self.viewModel.altPhotoDescription.flatMap {
                Text($0)
                    .italic()
                    .setFont(style: .body)
            }

            self.viewModel.photoDescription.flatMap {
                Text($0)
                    .setFont(style: .body)
            }
            Spacer()
            AboutUserView(viewModel: self.viewModel)
            // For extra space at bottom
            Rectangle()
                .fill(Color.clear)
                .frame( height: 100)
        }
        .foregroundColor(.white)
        .setFont(style: .body)
        .padding([.leading, .trailing], 12)
    }

    var body: some View {
        VStack(spacing: 0) {
            header
            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    ZStack {
                        self.urlImage
                        AnimatingHeart(isLiked: self.$viewModel.isLiked)
                            .offset(x: -40, y: -30)
                            .onTapGesture {
                                self.viewModel.didTapHeart()
                                self.onChange?()
                            }
                    }
                    self.detailsView
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            self.viewModel.blurImage?.resizable()
        )
        .ignoresSafeArea()
    }
}
