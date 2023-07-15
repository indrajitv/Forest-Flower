//
//  SavedPhotosViewModel.swift
//  Forest Flower
//
//  Created by Indrajit Chavda on 17/06/23.
//

import Foundation

@MainActor
final class SavedPhotosViewModel: ObservableObject {

    @Published
    var photoViewModels: [PhotoViewModel] = []

    @Published
    var selectedPhoto: PhotoViewModel!

    let title: String = "Saved Photos"

    let nothingToShow: String = "Nothing to show"

    let photoWillAppearHere: String = "Downloaded photos will appear here."
    
    func loadSavedPhotos() throws {
        photoViewModels = try ManagedSavedPhoto.getPhotos()
    }

    func remove(viewModel: PhotoViewModel) {
        photoViewModels.removeAll(where: { $0.id == viewModel.id })
    }
}
