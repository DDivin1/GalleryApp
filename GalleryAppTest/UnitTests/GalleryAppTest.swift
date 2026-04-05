//
//  GalleryAppTest.swift
//  GalleryAppTest
//
//  Created by Dmitry  Divin on 26.03.26.
//

import XCTest
import Combine
import Foundation

@testable import GalleryApp

final class ImageGalleryViewModelTest: XCTestCase {
    
    var sut: ImageGalleryViewModel!
    var networkStub: NetworkServiceStub!
    var storageMock: FavoritesStorageMock!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        networkStub = NetworkServiceStub()
        storageMock = FavoritesStorageMock()
        cancellables = Set<AnyCancellable>()
        
        sut = ImageGalleryViewModel(networkService: networkStub, favoritesStorage: storageMock)
    }
    
    override func tearDown() {
        sut = nil
        networkStub = nil
        storageMock = nil
        cancellables = nil
        super.tearDown()
    }
    
    func test_loadInitialImages_success() {
        // Given
        let expentation = self.expectation(description: "Image loaded succsessfully")
        let testImages = [
            makeTestImage(id: "1"),
            makeTestImage(id: "2")
        ]
        networkStub.setSuccessResult(testImages)
        
        var receivedImages: [Images] = []
        
        sut.$images
            .dropFirst()
            .sink { images in
                receivedImages = images
                expentation.fulfill()
            }
        
            .store(in: &cancellables)
        
        // When
        sut.loadInitialImages()
        
        // Then
        waitForExpectations(timeout: 3.0)
        XCTAssertTrue(networkStub.fetchImagesCalled)
        XCTAssertEqual(networkStub.lastPage, 1)
        XCTAssertEqual(networkStub.lastPerPage, 30)
        XCTAssertEqual(receivedImages.count, 2)
    }
    
    func testToggleFavorite_updateFavoritesIDs() {
        // Given
        let testImage = makeTestImage(id: "image1234")
        sut.images = [testImage]
        storageMock.setMocksFavoritesIds(["image1234"])
        
        // When
        sut.toggleFavorite(for: "image1234")
        
        // Then
        XCTAssertTrue(storageMock.toggleFavoriteCalled)
        XCTAssertTrue(sut.favoritesIDs.contains("image1234"))
        
    }
    
    private func makeTestImage(id: String) -> Images {
        Images(
            id: id,
            description: "Test image description",
            altDescription: nil,
            likes: 42,
            createdAt: "2025-04-05",
            urls: ImagesURLs(
                raw: nil,
                full: nil,
                regular: "https://example.com/image.jpg",
                small: nil,
                thumb: nil
            ),
            user: User(name: "Test user", username: "testured")
        )
    }
    
}
