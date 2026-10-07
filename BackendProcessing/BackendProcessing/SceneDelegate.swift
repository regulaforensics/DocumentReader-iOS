//
//  SceneDelegate.swift
//  BackendProcessing
//
//  Created by Anton Potapchik on 17.09.26.
//  Copyright © 2026 Regula. All rights reserved.
//

import UIKit

@objc(SceneDelegate)
class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard scene is UIWindowScene else { return }
    }
}
