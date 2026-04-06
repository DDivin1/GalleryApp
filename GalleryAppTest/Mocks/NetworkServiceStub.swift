//
//  NetworkServiceStub.swift
//  GalleryApp
//
//  Created by Dmitry  Divin on 5.04.26.
//

@testable import GalleryApp
import Combine
import Foundation

// MARK: - NetworkServiceStub
final class NetworkServiceStub: INetworkService {
    var fetchImageResult: Result<[Images], Error>?
    var fetchImagesCalled = false
    var lastPage: Int?
    var lastPerPage: Int?
    
    // MARK: - Public Methods
    func fetchImages(page: Int, perPage: Int) -> AnyPublisher<[Images], Error> {
        fetchImagesCalled = true
        lastPage = page
        lastPerPage = perPage
        
        guard let result = fetchImageResult else {
            return Fail(error: URLError(.badServerResponse)).eraseToAnyPublisher()
        }
        switch result {
        case .success(let images):
            return Just(images)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        case .failure(let error):
            return Fail(error: error).eraseToAnyPublisher()
        }
    }
    
    // MARK: - Helpers
    func setSuccessResult(_ images: [Images]) {
        fetchImageResult = .success(images)
    }
    
    func setFailureResult(_ error: Error) {
        fetchImageResult = .failure(error)
    }
}
