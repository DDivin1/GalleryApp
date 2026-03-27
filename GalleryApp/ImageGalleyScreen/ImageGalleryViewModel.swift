//
//  ImageGalleryViewModel.swift
//  GalleryApp
//
//  Created by Dmitry  Divin on 25.03.26.
//
import Combine
import UIKit

final class ImageGalleryViewModel {
    
    weak var coordinator: AppCoordinator?
    
    @Published var images: [Images] = []
    @Published var isLoading: Bool = false
    @Published var isLoadingMore: Bool = false
    @Published var errorMessage: String?
    
    private let networkService: INetworkService
    private let favoritesStorage: IFavoritesStorage
    
    private var currentPage = AppConstants.Numbers.currentPage
    private var canLoadMore: Bool = true
    private var cancellables: Set<AnyCancellable> = []
    
    
    init (networkService: INetworkService, favoritesStorage: IFavoritesStorage) {
        self.networkService = networkService
        self.favoritesStorage = favoritesStorage
    }
    
    func loadInitialImages() {
        guard !isLoading else { return }
        
        isLoading = true
        errorMessage = nil
        currentPage = AppConstants.Numbers.currentPage
        
        networkService.fetchImages(page: currentPage, perPage: AppConstants.Numbers.numberOfFetchingImages)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] newImages in
                self?.images = newImages
                self?.currentPage = 1
                self?.canLoadMore = !newImages.isEmpty
            }
            .store(in: &cancellables)
    }
    
    func loadMoreImages() {
        guard canLoadMore, !isLoadingMore else { return }
        
        isLoadingMore = true
        currentPage += 1
        
        networkService.fetchImages(page: currentPage, perPage: AppConstants.Numbers.numberOfFetchingImages)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoadingMore = false
                
                if case .failure(let error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] newImages in
                guard let self = self else {return}
                self.images.append(contentsOf: newImages)
                self.canLoadMore = !newImages.isEmpty
            }
            .store(in: &cancellables)
    }
    
    
}
