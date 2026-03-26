//
//  NetworkService.swift
//  GalleryApp
//
//  Created by Dmitry  Divin on 25.03.26.
//

import Foundation
import Combine

protocol INetworkService{
    
    func fetchImages(page: Int, perPage: Int) -> AnyPublisher<[Images], Error>
    
}

final class NetworkService: INetworkService {
    
    private let accessKey = AppConstants.unsplashAccessKey
    
    func fetchImages(page: Int, perPage: Int = AppConstants.Numbers.numberOfFetchingImages) -> AnyPublisher<[Images], Error> {
        let urlString = "https://api.unsplash.com/photos?page=\(page)&per_page=\(perPage)&order_by=latest"
        
        guard let url = URL(string: urlString) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.setValue("Client-ID \(accessKey)", forHTTPHeaderField: "Authorization")
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: [Images].self, decoder: JSONDecoder())
            .mapError { $0 as Error}
            .eraseToAnyPublisher()
    }
    
}

