//
//  SceneDelegate.swift
//  RunnerMate
//
//  Created by Herbert Dodge on 5/23/21.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let scene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: scene)
        window?.rootViewController = MapVC()
        window?.makeKeyAndVisible()
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        RunControlViewModel.shared.saveTimeData()
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        if MapViewModel.shared.checkIfRunDataExsists() {
            RunControlViewModel.shared.loadTimeData()
        }
    }

}

