//
//  AppDelegate.swift
//  HARDMAD 2
//
//  Created by Gleb Korotkov on 19.02.2025.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UserDefaults.standard.set(false, forKey: "NSLogToOSLogEnabled")
        
        UILabel.appearance().font = UIFont(name: "Gwen-Trial-Bold", size: 16)
        UIButton.appearance().titleLabel?.font = UIFont(name: "Gwen-Trial-Bold", size: 16)
        
        return true
    }

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return .portrait
    }

}

