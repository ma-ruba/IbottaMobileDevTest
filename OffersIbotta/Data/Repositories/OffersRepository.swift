//
//  OffersRepository.swift
//  OffersIbotta
//
//  Created by Mariia on 6/18/23.
//

import Foundation

protocol OffersRepository {
    func fetchOffersList(completion: @escaping (Result<[Offer], Error>) -> Void)
}

final class DefaultOffersRepository {
    
    private let dataTransferService: DataTransferService
    
    init(dataTransferService: DataTransferService) {
        self.dataTransferService = dataTransferService
    }
}

// MARK: - OffersRepository

extension DefaultOffersRepository: OffersRepository {
    func fetchOffersList(completion: @escaping (Result<[Offer], Error>) -> Void) {
        let endpoint = APIEndpoints.getOffers()
        dataTransferService.request(with: endpoint) { (result: Result<[OfferDTO], DataTransferError>) in
            switch result {
            case let .success(offersDTO):
                completion(.success(offersDTO.map { $0.toDomain() }))
                
            case let .failure(error):
                completion(.failure(error as Error))
            }
        }
    }
}
