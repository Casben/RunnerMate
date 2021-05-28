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
    

    func sceneWillEnterForeground(_ scene: UIScene) {
        RunControlViewModel.shared.loadTimeData()
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        RunControlViewModel.shared.timer.invalidate()
        RunControlViewModel.shared.saveTimeData()
    }
    
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        RunControlViewModel.shared.timer.invalidate()
        RunControlViewModel.shared.saveTimeData()
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        RunControlViewModel.shared.saveTimeData()
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        RunControlViewModel.shared.loadTimeData()
    }
    

}

