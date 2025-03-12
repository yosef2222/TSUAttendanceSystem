//
//  SceneDelegate.swift
//  HARDMAD 2
//
//  Created by Gleb Korotkov on 19.02.2025.
//

import UIKit

enum WindowCase {
    case register
    case main
}

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        NotificationCenter.default.addObserver(self, selector: #selector(windowManager), name: .windowManager, object: nil)
        
        guard let scene = (scene as? UIWindowScene) else { return }
        self.window = UIWindow(windowScene: scene)
        
        if TokenManager.shared.isLoggedIn() {
            TokenManager.shared.validateToken { isValid in
                DispatchQueue.main.async {
                    if isValid {
                        print("Токен валиден")
                        self.window?.rootViewController = UINavigationController(rootViewController: TabBarController())
                    } else {
                        print("Токен невалиден или произошла ошибка")
                        TokenManager.shared.deleteToken()
                        self.window?.rootViewController = UINavigationController(rootViewController: RegisterController())
                    }
                }
            }
        } else {
            self.window?.rootViewController = UINavigationController(rootViewController: RegisterController())
        }
        
        
        
        self.window?.makeKeyAndVisible()
    }

    @objc func windowManager(notification: Notification) {
        // Обработка уведомления
    }
}
