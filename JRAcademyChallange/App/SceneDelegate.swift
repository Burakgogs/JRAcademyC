//
//  SceneDelegate.swift
//  JRAcademyChallange
//
//  Created by Burak GÖĞÜŞ on 1.06.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  var window: UIWindow?
  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    guard let windowScene = (scene as? UIWindowScene) else { return }
    let window = UIWindow(windowScene: windowScene)
    let mainController = MainViewController()
    let navigateController = UINavigationController(rootViewController: mainController)
    window.rootViewController = navigateController
    window.makeKeyAndVisible()
    self.window = window
  }
}
