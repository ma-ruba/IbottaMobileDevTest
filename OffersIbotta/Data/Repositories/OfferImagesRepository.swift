//
//  OfferImagesRepository.swift
//  OffersIbotta
//
//  Created by Mariia on 6/17/23.
//

import UIKit

protocol OfferImagesRepository {
    func fetchImage(with imagePath: String, completion: @escaping (Result<UIImage?, Error>) -> Void)
}

final class DefaultOfferImagesRepository {
    
    private let storage: OfferImagesStorage
    private let dataTransferService: DataTransferService
    private let cacheLock = NSLock()

    init(
        dataTransferService: DataTransferService,
        storage: OfferImagesStorage
    ) {
        self.dataTransferService = dataTransferService
        self.storage = storage
    }
}

    // MARK: - OfferImagesRepository

extension DefaultOfferImagesRepository: OfferImagesRepository {
    func fetchImage(with imagePath: String, completion: @escaping (Result<UIImage?, Error>) -> Void) {
        
        if let cachedImageData = storage.getImage(for: imagePath) {
            completion(.success(cachedImageData))
        } else {
            let endpoint = APIEndpoints.getOfferImage(path: imagePath)
            dataTransferService.request(with: endpoint) { [weak self] (result: Result<Data, DataTransferError>) in
                switch result {
                case let .success(data):
                    let image = UIImage(data: data)
                    if let image {
                        self?.storage.setImage(image, for: imagePath)
                    }
                    completion(.success(image))
                case let .failure(error):
                    completion(.failure(error as Error))
                }
            }
        }
    }
}
    
