//
//  AppDIContainer.swift
//  OffersIbotta
//
//  Created by Mariia on 6/19/23.
//

import Foundation

final class AppDIContainer {
    
    // MARK: Network
    
    lazy var dataTransferService: DataTransferService = {
        let network = DefaultNetworkService()
        return DefaultDataTransferService(with: network)
    }()
    
    // MARK: - DIContainers of scenes
    
    func makeOffersSceneDIContainer() -> OffersSceneDIContainer {
        let dependencies = OffersSceneDIContainer.Dependencies(dataTransferService: dataTransferService)
        return OffersSceneDIContainer(dependencies: dependencies)
    }
}
