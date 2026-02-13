//
//  SceneDelegate.swift
//  AppClip-sample
//
//  Created by Ihar Yalavoi on 18.12.25.
//  Copyright © 2025 Dmitry Smolyakov. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    // MARK: - Constants
    
    private static let pendingURLKey = "AppClipPendingURL"
    private static let maxRetries = 10
    private static let initialRetryDelay: TimeInterval = 0.1
    
    // MARK: - Properties
    
    var window: UIWindow?
    private var pendingURL: URL?
    
    // MARK: - UIWindowSceneDelegate
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        if let userActivity = connectionOptions.userActivities.first,
           userActivity.activityType == NSUserActivityTypeBrowsingWeb,
           let url = userActivity.webpageURL {
            pendingURL = url
        }
        connectionOptions.urlContexts.first.map { pendingURL = $0.url }
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        if let url = pendingURL {
            pendingURL = nil
            handleURLWithRetry(url, in: scene, retryCount: 0)
        } else if let qrCodeURLString = UserDefaults.standard.string(forKey: Self.pendingURLKey),
                  let qrCodeURL = URL(string: qrCodeURLString) {
            UserDefaults.standard.removeObject(forKey: Self.pendingURLKey)
            handleURLWithRetry(qrCodeURL, in: scene, retryCount: 0)
        }
    }
    
    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        guard userActivity.activityType == NSUserActivityTypeBrowsingWeb,
              let url = userActivity.webpageURL else { return }
        handleURLWithRetry(url, in: scene, retryCount: 0)
    }
    
    private func handleURLWithRetry(_ url: URL, in scene: UIScene, retryCount: Int) {
        DispatchQueue.main.async {
            guard let windowScene = scene as? UIWindowScene,
                  let window = windowScene.windows.first,
                  let rootViewController = window.rootViewController else {
                return self.retryIfNeeded(url: url, scene: scene, retryCount: retryCount)
            }
            
            let viewController: ViewController? = {
                if let navController = rootViewController as? UINavigationController {
                    return navController.viewControllers.first as? ViewController
                }
                return rootViewController as? ViewController
            }()
            
            guard let viewController = viewController, viewController.isViewLoaded else {
                UserDefaults.standard.set(url.absoluteString, forKey: Self.pendingURLKey)
                return self.retryIfNeeded(url: url, scene: scene, retryCount: retryCount)
            }
            
            UserDefaults.standard.removeObject(forKey: Self.pendingURLKey)
            viewController.setConfigURL(url)
        }
    }
    
    private func retryIfNeeded(url: URL, scene: UIScene, retryCount: Int) {
        guard retryCount < Self.maxRetries else { return }
        let delay = Self.initialRetryDelay * pow(2.0, Double(retryCount))
        DispatchQueue.main.asyncAfter(deadline: .now() + min(delay, 1.0)) {
            self.handleURLWithRetry(url, in: scene, retryCount: retryCount + 1)
        }
    }
}
