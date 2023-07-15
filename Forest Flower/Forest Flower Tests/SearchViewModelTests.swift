//
//  SearchViewModelTests.swift
//  Forest Flower Tests
//
//  Created by Indrajit Chavda on 09/07/23.
//

import XCTest
import Combine

@testable import Forest_Flower

@MainActor
final class SearchViewModelTests: XCTestCase {

    typealias MockedPhotosManager = MockedAPIManager<[APIPhoto]>

    @BundleFileLoader(name: "SearchPhotosResult", type: "json", bundle: .init(for: HomeViewModelTests.self))
    var mockedResponseData: Data!

    private var publishers: Set<AnyCancellable> = []

    func test_getImage_paginationCountShouldIncreaseAndShouldStopIncreasingOnEmtyData() async {

        let sut = makeSUT(situation: .data(data: self.mockedResponseData!))
        let vm = sut.vm
        let apiManager = sut.apiManager

        XCTAssertEqual(vm.currentPage, 1) // Default is 1.

        await vm.getImages(current: nil) // Loaded data.
        XCTAssertEqual(vm.currentPage, 2) // +1

        await vm.getImages(current: vm.photoCallViewModels.last!)
        XCTAssertEqual(vm.currentPage, 3) // +1

        apiManager.situation = .error
        await vm.getImages(current: vm.photoCallViewModels.last!)
        // If error came while pagination, We do not do anything, This should not effect users, They may try again.
        XCTAssertEqual(vm.currentPage, 3)

        apiManager.situation = .data(data: self.mockedResponseData!)
        await vm.getImages(current: vm.photoCallViewModels.last!)
        // After error this is another attempt which should follow regular flow.
        XCTAssertEqual(vm.currentPage, 4) // +1

        apiManager.situation = .data(data: self.getEmptyResult()) // Empty array
        // We are demanding empty array from response.
        await vm.getImages(current: vm.photoCallViewModels.last!)
        // Now seems like hit the bottom of API means no data from server's end.
        XCTAssertEqual(vm.currentPage, -1)
    }

    func test_getImage_onceLoadedAllPhotosShouldNotDoAnythingOnNextCall() async {

        let sut = makeSUT(situation: .data(data: self.mockedResponseData!))
        let vm = sut.vm
        let apiManager = sut.apiManager
        let results = mockedResponseDataToModel().results

        await vm.getImages(current: nil)
        XCTAssertEqual(vm.currentPage, 2)
        XCTAssertEqual(vm.photoCallViewModels.count, results.count)

        await vm.getImages(current: vm.photoCallViewModels.last!)
        XCTAssertEqual(vm.currentPage, 3)
        XCTAssertEqual(vm.photoCallViewModels.count, results.count * 2)

        apiManager.situation = .data(data: self.getEmptyResult()) // Empty array
        await vm.getImages(current: vm.photoCallViewModels.last!)
        XCTAssertEqual(vm.currentPage, -1)
        // Remains same as it was before.
        XCTAssertEqual(vm.photoCallViewModels.count, results.count * 2)

        apiManager.situation = .data(data: self.mockedResponseData!)
        await vm.getImages(current: vm.photoCallViewModels.last!)
        XCTAssertEqual(vm.currentPage, -1)
        // Remains same as it was before.
        XCTAssertEqual(vm.photoCallViewModels.count, results.count * 2)
    }

    func test_getImage_shouldRemoveCacheAndStartFreshPagination_ifThereAreAlreadyLoadedDataAndParameterForPaginationIsNil() async {

        let sut = makeSUT(situation: .data(data: self.mockedResponseData!))
        let vm = sut.vm
        let results = mockedResponseDataToModel().results

        await vm.getImages(current: nil)
        XCTAssertEqual(vm.currentPage, 2)
        XCTAssertEqual(vm.photoCallViewModels.count, results.count)

        await vm.getImages(current: nil)
        XCTAssertEqual(vm.currentPage, 2)
        XCTAssertEqual(vm.photoCallViewModels.count, results.count)
    }

    func test_clearAllImages_onCall_shouldRemovedAllImage() async {

        let sut = makeSUT(situation: .data(data: self.mockedResponseData!))
        let vm = sut.vm
        let results = mockedResponseDataToModel().results

        await vm.getImages(current: nil)
        XCTAssertEqual(vm.photoCallViewModels.count, results.count)

        vm.clearAllImages()

        XCTAssertEqual(vm.photoCallViewModels.count, 0)
    }

    func test_stringAndConstants_shouldBeAllExpectedWithDefaultValues() {

        let sut = makeSUT(situation: .data(data: self.mockedResponseData!))
        let vm = sut.vm

        XCTAssertEqual(vm.query, "")
        XCTAssertEqual(vm.isSearching, false)

        XCTAssertEqual(vm.retryTitle, "Retry")
        XCTAssertEqual(vm.oops, "Oops!")
        XCTAssertEqual(vm.searchPlaceholder, "Search")
        XCTAssertEqual(vm.nothingToShow, "Nothing to show, Search something cool!")
    }

    func test_observeSearchQuery_dropFirstValueRemoveDuplicatesAndFilterStringToChecCountsTwoOrMore_whenPublishesOnOrMoreValues() {

        let sut = makeSUT(situation: .data(data: self.mockedResponseData!))
        let results = mockedResponseDataToModel().results
        let vm = sut.vm

        XCTAssertTrue(vm.photoCallViewModels.isEmpty, "Before search attempt it should be empty.")
        XCTAssertFalse(vm.isSearching, "Before search attempt it should be false.")

        vm.query = "h"
        XCTAssertFalse(vm.isSearching, "On first attempt it should be still false as we drop first element.")

        vm.query = "ho  "
        XCTAssertFalse(vm.isSearching, "Char counts < 2 excluding white spaces, It should filtered out.")

        var totalValueReceivedFromService: [PhotoViewModel] = []
        vm.$photoCallViewModels
            .sink { values in
                totalValueReceivedFromService.append(contentsOf: values)
            }
            .store(in: &self.publishers)

        vm.query = "home"
        vm.query = "home home"
        vm.query = "home home home"
        vm.query = "home home home"
        vm.query = "home"
        XCTAssertTrue(vm.isSearching)

        let expectation1 = expectation(description: "Should get some response and fill the array.")

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) {
            // We are waiting for n seconds as we have set debounce.
            if totalValueReceivedFromService.count == results.count {
                // Despite searched for multiple queries, Due to debounce API should called only once.
                expectation1.fulfill()
            }
        }
        wait(for: [expectation1], timeout: 1)

        XCTAssertEqual(vm.currentPage, 2, "On each search we make currentPage = 1, After response it must be +1 that means == 2.")

        vm.query = "home"
        XCTAssertFalse(vm.isSearching, "After second attempt with same value, it should be false as we ignore duplicates.")

        vm.query = "home sweet home"
        XCTAssertTrue(vm.isSearching, "Should start search...")

        let expectation2 = expectation(description: "Should get response second time and fill the array which means array size of double.")

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) {
            // We are waiting for n seconds as we have set debounce.
            if totalValueReceivedFromService.count == results.count * 2,
               vm.photoCallViewModels.count == results.count { // We every time remove main array. New count is == new response.
                expectation2.fulfill()
            }
        }
        wait(for: [expectation2], timeout: 1)

        XCTAssertEqual(vm.currentPage, 2, "On each search we make currentPage = 1, After response it must be +1 that means == 2.")
        XCTAssertFalse(vm.isSearching, "Not searching after getting response.")
    }

    func getEmptyResult() -> Data {
        return """
            {"total":10000,"total_pages":400,"results":[]}
        """.data(using: .utf8)!
    }

    func mockedResponseDataToModel() -> APISearchResult {
        return try! JSONDecoder().decode(APISearchResult.self, from: self.mockedResponseData)
    }

    func makeSUT(situation: MockedPhotosManager.MockedSituation) -> (vm: SearchViewModel, apiManager: MockedPhotosManager) {

        let apiManage = MockedPhotosManager(situation: situation)
        let viewModel = SearchViewModel(apiManager: apiManage)

        return (viewModel, apiManage)
    }

}
