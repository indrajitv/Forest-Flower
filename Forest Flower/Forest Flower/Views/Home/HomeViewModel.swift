//
//  HomeViewModel.swift
//  Forest Flower
//
//  Created by Indrajit Chavda on 10/06/23.
//

import SwiftUI

@MainActor
protocol PhotoLoadable: ObservableObject {

    var photoCallViewModels: [PhotoViewModel] { get }

    var selectedPhoto: PhotoViewModel! { get set }

    func getImages(current: PhotoViewModel?) async throws
}

@MainActor
final class HomeViewModel: PhotoLoadable {

    private let apiManager: APIManageable

    @Published
    var selectedPhoto: PhotoViewModel!

    @Published
    private(set) var photoCallViewModels: [PhotoViewModel] = []

    @Published
    var currentError: String?

    @Published
    var currentListingStyle: DynamicGrid.Grid = .single

    let headerTitle: String = "🌼 Forest Flower"

    let retryTitle: String = "Retry"

    let oops: String = "Oops!"

    private(set) var currentPage: Int = 1

    init(apiManager: APIManageable = APIManager()) {
        self.apiManager = apiManager
    }
    
    func getImages(current: PhotoViewModel?) async {

        if currentPage == -1 {
            return
        }

        if !self.photoCallViewModels.isEmpty, current == nil {
            return
        }

        if let current = current {
            
            if !photoCallViewModels.isEmpty,
               current.id.uuidString != photoCallViewModels.last?.id.uuidString ?? "-" { return }

        } else {
            self.currentPage = 1
            photoCallViewModels.removeAll()
        }

        do {
            let photos = try await apiManager.request(with: FetchPhotos.getHomeFeed(parameters: .init(page: self.currentPage, perPage: 50, orderBy: .latest)),
                                                      for: [APIPhoto].self)

            if !photos.isEmpty {
                photoCallViewModels.append(contentsOf: photos.map { PhotoViewModel.init(photo: $0) })
                currentPage += 1
            } else {
                currentPage = -1
            }
        } catch let error {

            if self.shouldShowErrorOnScreen() {
                self.currentError = (error as? CustomError)?.desc ?? error.localizedDescription
            }
        }
    }

    func shouldShowErrorOnScreen() -> Bool {
        return self.currentPage == 1
    }
}
