//
//  OffersFlowCoordinator.swift
//  OffersIbotta
//
//  Created by Mariia on 6/19/23.
//

import Foundation
import UIKit

final class OffersFlowCoordinator {
    private weak var navigationController: UINavigationController?
    private let offersSceneDIContainer: OffersSceneDIContainer
    
    init(
        offersSceneDIContainer: OffersSceneDIContainer,
        navigationController: UINavigationController?
    ) {
        self.navigationController = navigationController
        self.offersSceneDIContainer = offersSceneDIContainer
    }
    
    func start() {
        let actions = OffersListViewModelActions(showOfferDetais: showOfferDetails)
        let vc = offersSceneDIContainer.makeOffersListViewController(actions: actions)
        navigationController?.pushViewController(vc, animated: false)
    }
    
    private func showOfferDetails(offer: Offer) {
        let vc = offersSceneDIContainer.makeOfferDetailsViewController(offer: offer)
        navigationController?.pushViewController(vc, animated: true)
    }
}
