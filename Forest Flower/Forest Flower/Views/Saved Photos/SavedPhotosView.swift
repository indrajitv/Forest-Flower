//
//  SavedPhotosView.swift
//  Forest Flower
//
//  Created by Indrajit Chavda on 17/06/23.
//

import SwiftUI

struct SavedPhotosView: View {

    @StateObject
    var viewModel: SavedPhotosViewModel = SavedPhotosViewModel()

    var errorView: some View {
        ErrorHoarding(systemImage: SystemImage.photoStack,
                      title: self.viewModel.nothingToShow,
                      subTitle: self.viewModel.photoWillAppearHere,
                      retryButtonTitle: nil)
    }

    var photoViewer: some View {
        ScrollView(.vertical) {
            LazyVStack(spacing: 5) {
                ForEach(viewModel.photoViewModels) { viewModel in
                    PhotoView(imageWidth: UIScreen.main.bounds.width, viewModel: viewModel, showDownloadDetailsAutomaticIfAvailable: true) {
                        try? viewModel.removeFromDownloadedList()

                        withAnimation(.linear(duration: 0.2)) {
                            self.viewModel.remove(viewModel: viewModel)
                        }
                    }
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
                            PhotoDetailsView(viewModel: photo)
                        }
                }
            }
            .setLinearBG()
        }
        .onAppear {
            try? self.viewModel.loadSavedPhotos()
        }
    }
}

struct SavedPhotosView_Previews: PreviewProvider {
    static var previews: some View {
        SavedPhotosView()
    }
}
