//
//  SearchResultView.swift
//  Forest Flower
//
//  Created by Indrajit Chavda on 19/06/23.
//

import SwiftUI

struct SearchResultView: View {
    
    @StateObject
    private var viewModel = SearchViewModel()
    
    var searchField: some View {
        SearchTextField(searchText: self.$viewModel.query, placeholder: self.viewModel.searchPlaceholder)
    }
    
    var progress: some View {
        ProgressView()
    }
    
    var gridView: some View {
        ScrollView(.vertical) {
            DynamicGrid(viewModel: self.viewModel, grid: .single) {
                self.loadData(current: $0)
            }
        }
    }

    var noSearchResultView: some View {
        Text(self.viewModel.nothingToShow)
            .padding()
            .setFont(style: .subTitle)
            .foregroundColor(.white)
    }

    var body: some View {
        VStack {
            self.searchField
            ZStack {
                if self.viewModel.isSearching {
                    self.progress
                } else if self.viewModel.query.isEmpty {
                    CategoryGrid { category in
                        withAnimation(.easeIn(duration: 0.2)) {
                            self.viewModel.clearAllImages()
                            self.viewModel.query = category.getTitle()
                        }
                    }
                    .transition(.opacity)
                } else if !self.viewModel.photoCallViewModels.isEmpty {
                    self.gridView
                } else {
                    self.noSearchResultView
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .setLinearBG()
        .sheet(item: self.$viewModel.selectedPhoto) { PhotoDetailsView(viewModel: $0) }
    }

    func loadData(current: PhotoViewModel?) {
        Task {
            await viewModel.getImages(current: current)
        }
    }
}
