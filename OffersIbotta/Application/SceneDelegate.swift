//
//  SceneDelegate.swift
//  OffersIbotta
//
//  Created by Mariia on 6/13/23.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    let appDIContainer = AppDIContainer()
    var appFlowCoordinator: AppFlowCoordinator?
    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        AppAppearance.setupAppearance()
        
        window = UIWindow(windowScene: windowScene)
        
        let navigationController = UINavigationController()
        window?.rootViewController = navigationController
        
        appFlowCoordinator = AppFlowCoordinator(
            navigationController: navigationController,
            appDIContainer: appDIContainer
        )
        appFlowCoordinator?.start()
        
        window?.makeKeyAndVisible()
    }
}

