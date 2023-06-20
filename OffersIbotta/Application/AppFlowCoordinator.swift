//
//  AppFlowCoordinator.swift
//  OffersIbotta
//
//  Created by Mariia on 6/19/23.
//

import UIKit

final class AppFlowCoordinator {
    
    var navigationController: UINavigationController
    private let appDIContainer: AppDIContainer
    
    init(navigationController: UINavigationController,
         appDIContainer: AppDIContainer) {
        self.navigationController = navigationController
        self.appDIContainer = appDIContainer
    }
    
    func start() {
        let offersSceneDIContainer = appDIContainer.makeOffersSceneDIContainer()
        let flow = offersSceneDIContainer.makeOffersFlowCoordinator(navigationController: navigationController)
        flow.start()
    }
}
