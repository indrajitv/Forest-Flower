//
//  LikesView.swift
//  Forest Flower
//
//  Created by Indrajit Chavda on 02/07/23.
//

import SwiftUI

struct LikesView: View {

    @StateObject
    var viewModel: LikesViewModel = LikesViewModel()

    var errorView: some View {
        ErrorHoarding(systemImage: SystemImage.heartFilled,
                      title: self.viewModel.nothingToShow,
                      subTitle: self.viewModel.photoWillAppearHere,
                      retryButtonTitle: nil)
    }

    var photoViewer: some View {
        ScrollView(.vertical) {
            LazyVStack(spacing: 5) {
                ForEach(viewModel.photoViewModels) { viewModel in
                    PhotoView(imageWidth: UIScreen.main.bounds.width,
                              viewModel: viewModel, showDownloadDetailsAutomaticIfAvailable: false)
                    .onTapGesture {
                        self.viewModel.selectedPhoto = viewModel
                    }
                }
            }
            // Giving extra space at bottom.
            Rectangle()
                .foregroundColor(.clear)
                .frame(height: 200)
        }
    }

    var body: some View {
        NavigationView {
            ZStack {
                if self.viewModel.photoViewModels.isEmpty {
                    self.errorView
                } else {

                    self.photoViewer
                        .background(NavigationConfigurator { navigation in
                            navigation.hidesBarsOnSwipe = true
                        })
                        .navigationBarTitleDisplayMode(.inline)
                        .navigationTitle(self.viewModel.title)
                        .ignoresSafeArea()
                        .sheet(item: self.$viewModel.selectedPhoto) { photo in
                            PhotoDetailsView(viewModel: photo) {
                                // On change
                                try? self.viewModel.loadSavedPhotos()
                            }
                        }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .setLinearBG()
        }
        .onAppear {
            try? self.viewModel.loadSavedPhotos()
        }
    }
}

struct LikesView_Previews: PreviewProvider {
    static var previews: some View {
        LikesView()
    }
}
