//
//  DynamicGrid.swift
//  Forest Flower
//
//  Created by Indrajit Chavda on 17/06/23.
//

import SwiftUI

struct DynamicGrid: View {

    var viewModel: any PhotoLoadable

    let spacing: CGFloat = 5

    let grid: Grid

    init(viewModel: any PhotoLoadable, grid: Grid, onCellAppearance: ((_ viewModel: PhotoViewModel) -> ())?) {
        self.viewModel = viewModel
        self.grid = grid
        self.onCellAppearance = onCellAppearance
    }
    
    var body: some View {
        HStack(alignment: .top, spacing: spacing) {
            if grid == .single {
                getStack()
            } else {
                getStack(isOdd: false)
                getStack(isOdd: true)
            }
        }
        Rectangle()
            .foregroundColor(.clear)
            .frame(height: 200)
    }

    var onCellAppearance: ((_ viewModel: PhotoViewModel) -> ())?

    @MainActor
    @ViewBuilder
    func getStack(isOdd: Bool = false) -> some View {
        if grid == .single {
            LazyVStack(spacing: spacing) {
                ForEach(viewModel.photoCallViewModels) { viewModel in
                    PhotoView(imageWidth: UIScreen.main.bounds.width, viewModel: viewModel, showDownloadDetailsAutomaticIfAvailable: false)
                        .onTapGesture {
                            self.viewModel.selectedPhoto = viewModel
                        }
                        .onAppear {
                            self.onCellAppearance?(viewModel)
                        }
                }
            }
        } else {
            LazyVStack(spacing: spacing/2) {
                ForEach(0..<viewModel.photoCallViewModels.count, id: \.self) { index in
                    let result: Bool = isOdd ? (index % 2 != 0) : (index % 2 == 0)
                    if result {
                        let viewModel = viewModel.photoCallViewModels[index]
                        PhotoView(imageWidth: UIScreen.main.bounds.width/2, viewModel: viewModel, showDownloadDetailsAutomaticIfAvailable: false)
                            .onTapGesture {
                                self.viewModel.selectedPhoto = viewModel
                            }
                            .onAppear {
                                self.onCellAppearance?(viewModel)
                            }
                    }
                }
            }
        }
    }

    enum Grid: String {
        case single
        case double
    }
}
