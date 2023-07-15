//
//  SearchViewModel.swift
//  Forest Flower
//
//  Created by Indrajit Chavda on 24/06/23.
//

import Foundation
import Combine

@MainActor
final class SearchViewModel: PhotoLoadable {

    private let apiManager: APIManageable

    @Published
    private(set) var photoCallViewModels: [PhotoViewModel] = []
    
    @Published
    var query: String = ""

    @Published
    var isSearching: Bool = false

    let retryTitle: String = "Retry"
    let oops: String = "Oops!"

    let searchPlaceholder: String = "Search"

    let nothingToShow: String = "Nothing to show, Search something cool!"

    private var publishers: Set<AnyCancellable> = []

    @Published
    var selectedPhoto: PhotoViewModel!

    private(set) var currentPage: Int = 1

    init(apiManager: APIManageable = APIManager()) {

        self.apiManager = apiManager
        self.observeSearchQuery()
    }

    private func observeSearchQuery() {

        let queryPublisher = self.$query
            .dropFirst()
            .removeDuplicates()
            .filter { $0.replacingOccurrences(of: " ", with: "").count > 2 }

        queryPublisher.sink { _ in
            self.isSearching = true
        }
        .store(in: &publishers)

        queryPublisher
            .debounce(for: 0.8, scheduler: DispatchQueue.main)
            .sink { [weak self] query in

                guard let self = self else { return }

                self.currentPage = 1
                self.photoCallViewModels.removeAll()

                Task {
                    await self.getImages(current: nil)
                    self.isSearching = false
                }
            }
            .store(in: &publishers)
    }

    func clearAllImages() {
        self.photoCallViewModels.removeAll()
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

        let endPoint = SearchPhotos.search(parameters: .init(page: self.currentPage, perPage: 25, query: self.query))

        do {
            let results = try await apiManager.request(with: endPoint, for: APISearchResult.self).results

            if !results.isEmpty {
                photoCallViewModels.append(contentsOf: results.map { PhotoViewModel.init(photo: $0) })
                self.currentPage += 1
            } else {
                self.currentPage = -1
            }

        } catch {
            if currentPage == 1 { // API first time loaded, We may need to show retry button.
                currentPage = -1
            }
        }
    }
}
