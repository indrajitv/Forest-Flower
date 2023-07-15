//
//  HomeViewModelTests.swift
//  Forest Flower Tests
//
//  Created by Indrajit Chavda on 08/07/23.
//

import XCTest

@testable import Forest_Flower

@MainActor
final class HomeViewModelTests: XCTestCase {

    typealias MockedPhotosManager = MockedAPIManager<[APIPhoto]>

    @BundleFileLoader(name: "PhotosResponse", type: "json", bundle: .init(for: HomeViewModelTests.self))
    var responseMockedData: Data!

    func test_getImages_shouldPublishErrorFromCurrentError_whileFailureInLoadingWhenPageNumberIsOne() async {

        let sut = makeSUT(situation: .error).vm
        await sut.getImages(current: nil)

        XCTAssertNotNil(sut.currentError)
        XCTAssertEqual(sut.currentError!, CustomError.badRequest.desc)
    }

    func test_getImages_shouldNOTPublishErrorFromCurrentError_whileReturnsPhotosAndPageNumberGreaterThanOne() async {

        let sut = makeSUT(situation: .data(data: responseMockedData))
        let vm = sut.vm
        let apiManager = sut.apiManager

        await vm.getImages(current: nil) // Loaded data

        apiManager.situation = .error
        await vm.getImages(current: vm.photoCallViewModels.last!)
        // Loading with pagination, We do not expect error as we do not want to show it to user.

        XCTAssertNil(vm.currentError)
    }

    func test_getImage_paginationCountShouldIncreaseAndShouldStopIncreasingOnEmtyData() async {

        let sut = makeSUT(situation: .data(data: self.responseMockedData))
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

        apiManager.situation = .data(data: self.responseMockedData)
        await vm.getImages(current: vm.photoCallViewModels.last!)
        // After error this is another attempt which should follow regular flow.
        XCTAssertEqual(vm.currentPage, 4) // +1

        apiManager.situation = .data(data: "[]".data(using: .utf8)!) // Empty array
        // We are demanding empty array from response.
        await vm.getImages(current: vm.photoCallViewModels.last!)
        // Now seems like hit the bottom of API means no data from server's end.
        XCTAssertEqual(vm.currentPage, -1)
    }

    func test_getImage_onceLoadedAllPhotosShouldNotDoAnythingOnNextCall() async {

        let sut = makeSUT(situation: .data(data: self.responseMockedData))
        let vm = sut.vm
        let apiManager = sut.apiManager

        let apiPhotos = try! JSONDecoder().decode([APIPhoto].self, from: self.responseMockedData)

        await vm.getImages(current: nil)
        XCTAssertEqual(vm.currentPage, 2)
        XCTAssertEqual(vm.photoCallViewModels.count, apiPhotos.count)

        await vm.getImages(current: vm.photoCallViewModels.last!)
        XCTAssertEqual(vm.currentPage, 3)
        XCTAssertEqual(vm.photoCallViewModels.count, apiPhotos.count * 2)

        apiManager.situation = .data(data: "[]".data(using: .utf8)!) // Empty array
        await vm.getImages(current: vm.photoCallViewModels.last!)
        XCTAssertEqual(vm.currentPage, -1)
        // Remains same as it was before.
        XCTAssertEqual(vm.photoCallViewModels.count, apiPhotos.count * 2)

        apiManager.situation = .data(data: self.responseMockedData)
        await vm.getImages(current: vm.photoCallViewModels.last!)
        XCTAssertEqual(vm.currentPage, -1)
        // Remains same as it was before.
        XCTAssertEqual(vm.photoCallViewModels.count, apiPhotos.count * 2)
    }

    func test_getImage_shouldRemoveCacheAndStartFreshPagination_ifThereAreAlreadyLoadedDataAndParameterForPaginationIsNil() async {

        let sut = makeSUT(situation: .data(data: self.responseMockedData))
        let vm = sut.vm
        let apiPhotos = try! JSONDecoder().decode([APIPhoto].self, from: self.responseMockedData)

        await vm.getImages(current: nil)
        XCTAssertEqual(vm.currentPage, 2)
        XCTAssertEqual(vm.photoCallViewModels.count, apiPhotos.count)

        await vm.getImages(current: nil)
        XCTAssertEqual(vm.currentPage, 2)
        XCTAssertEqual(vm.photoCallViewModels.count, apiPhotos.count)
    }

    func test_shouldShowErrorOnScreen_shouldReturnTrueIfPaginationIsOne() async {

        let sut = makeSUT(situation: .data(data: self.responseMockedData))
        let vm = sut.vm

        XCTAssertTrue(vm.shouldShowErrorOnScreen()) // Means pagination is == 1

        await vm.getImages(current: nil)
        XCTAssertFalse(vm.shouldShowErrorOnScreen()) // Means pagination is != 1

        await vm.getImages(current: vm.photoCallViewModels.last!)
        XCTAssertFalse(vm.shouldShowErrorOnScreen()) // Means pagination is != 1
    }

    func test_defaultConstantValues() {

        let sut = makeSUT(situation: .data(data: self.responseMockedData))
        let vm = sut.vm

        XCTAssertEqual(vm.currentListingStyle, .single)
        XCTAssertEqual(vm.headerTitle, "🌼 Forest Flower")
        XCTAssertEqual(vm.retryTitle, "Retry")
        XCTAssertEqual(vm.oops, "Oops!")
    }

    func makeSUT(situation: MockedPhotosManager.MockedSituation) -> (vm: HomeViewModel, apiManager: MockedPhotosManager) {

        let apiManage = MockedPhotosManager(situation: situation)
        let viewModel = HomeViewModel(apiManager: apiManage)

        return (viewModel, apiManage)
    }
}
