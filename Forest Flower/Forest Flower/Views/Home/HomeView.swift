//
//  HomeView.swift
//  Forest Flower
//
//  Created by Indrajit Chavda on 10/06/23.
//

import SwiftUI

struct HomeView: View {

    @StateObject
    private var viewModel: HomeViewModel = HomeViewModel()

    var progressView: some View {
        ProgressView().progressViewStyle(.circular)
    }

    var photoGrid: some View {
        ScrollView(.vertical) {
            DynamicGrid(viewModel: self.viewModel,
                        grid: self.viewModel.currentListingStyle) {
                self.loadData(current: $0)
            }
        }
    }

    var body: some View {
        NavigationView {
            VStack {
                if let error = self.viewModel.currentError {
                    ErrorHoarding(systemImage: SystemImage.triangle,
                                  title: self.viewModel.oops,
                                  subTitle: error,
                                  retryButtonTitle: self.viewModel.retryTitle) {
                        self.viewModel.currentError = nil
                    }
                } else {
                    if self.viewModel.photoCallViewModels.isEmpty {
                        self.progressView
                    } else {
                        self.photoGrid
                    }
                }
            }
            .background(NavigationConfigurator { $0.hidesBarsOnSwipe = true })
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle(self.viewModel.headerTitle)
            .ignoresSafeArea()
            .toolbar(content: {
                ToolbarItem {
                    Button {
                        withAnimation(.easeInOut(duration: 0.8)) {
                            self.viewModel.currentListingStyle = self.viewModel.currentListingStyle == .single ? .double : .single
                        }
                    } label: {
                        withAnimation(.easeInOut(duration: 0.6)) {
                            (self.viewModel.currentListingStyle == .single ? SystemImage.grid : SystemImage.list)
                                .setFont(style: .subTitle)
                        }
                    }
                    .tint(.white)
                }
            })
            .sheet(item: self.$viewModel.selectedPhoto) { photo in
                PhotoDetailsView(viewModel: photo)
            }
            .setLinearBG()
        }.onAppear {
            self.loadData(current: nil)
        }
    }

    func loadData(current: PhotoViewModel?) {
        Task {
            await viewModel.getImages(current: current)
        }
    }
}
