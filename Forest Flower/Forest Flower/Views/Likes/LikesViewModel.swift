//
//  LikesViewModel.swift
//  Forest Flower
//
//  Created by Indrajit Chavda on 02/07/23.
//

import Foundation

@MainActor
final class LikesViewModel: ObservableObject {

    let title: String = "Likes"
    let nothingToShow: String = "Nothing to show"
    let photoWillAppearHere: String = "Liked photos will appear here."

    @Published
    var photoViewModels: [PhotoViewModel] = []

    @Published
    var selectedPhoto: PhotoViewModel!

    func loadSavedPhotos() throws {
        photoViewModels = try ManagedLikedPhoto.getPhotos()
    }

    func remove(viewModel: PhotoViewModel) {
        photoViewModels.removeAll(where: { $0.id == viewModel.id })
    }
}
