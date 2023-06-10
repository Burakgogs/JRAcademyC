//
//  GameViewController.swift
//  JRAcademyChallange
//
//  Created by Burak GÖĞÜŞ on 3.06.2023.
//
import UIKit
import SnapKit
import Carbon
final class MainViewController: UIViewController {
  private var customTabBarController: MainTabBarController! = MainTabBarController()

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    customTabBarController = MainTabBarController()
    addChild(customTabBarController)
    view.addSubview(customTabBarController.view)
    customTabBarController.view.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
    customTabBarController.didMove(toParent: self)
  }
  class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
      super.viewDidLoad()
      let tabOneVC = GameViewController()
      tabOneVC.tabBarItem = UITabBarItem(title: "Games", image: UIImage(named: "GameIcon"), tag: 0)
      let tabTwoVC = FavouritesViewController()
      tabTwoVC.tabBarItem = UITabBarItem(title: "Favorites", image: UIImage(named: "FavoriteIcon"), tag: 1)
      viewControllers = [tabOneVC, tabTwoVC]
    }
  }
}
