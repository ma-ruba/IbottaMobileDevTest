//
//  OffersSceneDIContainer.swift
//  OffersIbotta
//
//  Created by Mariia on 6/19/23.
//

import UIKit

final class OffersSceneDIContainer {
    
    struct Dependencies {
        let dataTransferService: DataTransferService
    }
    
    private let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    
    // MARK: - Repositories
    
    func makeOffersRepository() -> OffersRepository {
        return DefaultOffersRepository(dataTransferService: dependencies.dataTransferService)
    }
    
    func makeOfferImagesRepository() -> OfferImagesRepository {
        return DefaultOfferImagesRepository(dataTransferService: dependencies.dataTransferService, storage: ImageCache())
    }
    
    // MARK: - Offers List
    
    func makeOffersListViewController(actions: OffersListViewModelActions) -> OffersListViewController {
        return OffersListViewController(viewModel: makeOffersListViewModel(actions: actions), offerImagesRepository: makeOfferImagesRepository())
    }
    
    func makeOffersListViewModel(actions: OffersListViewModelActions) -> OffersListViewModel {
        return DefaultOffersListViewModel(
            actions: actions,
            offersRepository: makeOffersRepository()
        )
    }
    
    // MARK: - Offer Details
    
    func makeOfferDetailsViewController(offer: Offer) -> UIViewController {
        return OfferDetailsViewController(viewModel: makeOfferDetailsViewModel(offer: offer))
    }
    
    func makeOfferDetailsViewModel(offer: Offer) -> OfferDetailsViewModel {
        return DefaultOfferDetailsViewModel(offer: offer, offerImagesRepository: makeOfferImagesRepository())
    }
    
    // MARK: - Flow Coordinators
    
    func makeOffersFlowCoordinator(navigationController: UINavigationController) -> OffersFlowCoordinator {
        return OffersFlowCoordinator(offersSceneDIContainer: self, navigationController: navigationController)
    }
}
