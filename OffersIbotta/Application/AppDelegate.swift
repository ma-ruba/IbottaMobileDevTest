//
//  AppDelegate.swift
//  OffersIbotta
//
//  Created by Mariia on 6/13/23.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FavoritesManager.shared.loadFavorites()
        
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        FavoritesManager.shared.saveFavorites()
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return .portrait
    }
}

