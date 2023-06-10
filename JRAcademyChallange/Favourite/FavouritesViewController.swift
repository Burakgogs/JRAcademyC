//
//  FavoritesViewController.swift
//  JRAcademyChallange
//
//  Created by Burak GÖĞÜŞ on 4.06.2023.
//

import UIKit
import Foundation
import Carbon
import CoreData
import RealmSwift

class FavouritesViewController: UIViewController, GameViewModelDelegate {
  func didFetchGames() {}
  func searchGame() { }
  func didFetchMoreGames() { }
  func getDetailGames() {
    render()
  }
  private let tableView = UITableView()
  var gameID: Int?
  let labelTitle = UILabel()
  let navigationBar = UINavigationBar()
  var favouritesGames: [Int] = []
  var managedObjectContext: NSManagedObjectContext!
  var deletedItem: [Game] = []
  var comeData: [Todo] = []
  var renderData: [Todo] = []
  var gameSection = Section(id: "")
  var favCount = 0
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    renderer.adapter.favouritesController = self
    setupUI()
    setupConstraints()
    //      tableView.addSubview(emptyFavorite)
    renderer.target = tableView
    render()
    labelTitle.text = "Favorites(\(favCount))"
  }


  func setupUI() {
    view.addSubview(navigationBar)
    navigationBar.addSubview(labelTitle)
    view.addSubview(tableView)

    tableView.snp.makeConstraints { make in
      make.top.equalTo(navigationBar.snp.bottom)
      make.leading.equalTo(0)
      make.trailing.equalTo(0)
      make.bottom.equalToSuperview().offset(-83)
    }
    tableView.separatorStyle = .none
    tableView.contentInset = UIEdgeInsets(top: -20, left: 0, bottom: 0, right: 0)

    navigationBar.layer.cornerRadius = 0
    navigationBar.tintColor = .white
    navigationBar.topItem?.title = "Navigation Bar"
    navigationBar.backgroundColor = UIColor(red: 0.97, green: 0.97, blue: 0.97, alpha: 0.92)

    labelTitle.textColor = .black
    labelTitle.textAlignment = .left
    labelTitle.numberOfLines = 0
    labelTitle.lineBreakMode = .byWordWrapping
    labelTitle.textColor = .black
    labelTitle.adjustsFontSizeToFitWidth = true
    labelTitle.minimumScaleFactor = 0.5
    labelTitle.baselineAdjustment = .alignCenters
    labelTitle.font = UIFont(name: "Roboto-Bold", size: 34)
  }
  func setupConstraints() {
    labelTitle.snp.makeConstraints { make in
      make.top.equalTo(navigationBar).offset(90)
      make.left.equalTo(16)
      make.right.equalTo(250)
      make.bottom.equalTo(navigationBar).offset(-9)
      make.height.equalTo(41)
      make.width.equalTo(109)
    }
    navigationBar.snp.makeConstraints { make in
      make.height.equalTo(140)
      make.left.equalToSuperview()
      make.top.equalToSuperview()
      make.right.equalToSuperview()
    }
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    render()
  }


  private let renderer = Renderer(
    adapter: FavouriteAdapter(),
    updater: UITableViewUpdater()
  )

  func render() {
    var cellNode: [CellNode] = []
    renderData = []
    favouritesGames = []
    if let favorites = getFavourites() {
      renderData.append(contentsOf: favorites)
    } else {
      // Nil durumunda yapılacak işlemler
    }
    if renderData.isEmpty {
      let emptyNode = CellNode(id: "EmptyCell", EmptyFavItem())
      cellNode.append(emptyNode)
    } else {
      for favorite in renderData {
        favouritesGames.append(favorite.gameid)
        let gameNode = CellNode(
          id: String(favorite.gameid),
          GameItem(
            id: favorite.gameid,
            name: favorite.name,
            metacritic: favorite.metacritic,
            gameImage: favorite.image,
            genres: favorite.genres
          )
        )
        cellNode.append(gameNode)
        favCount += 1
      }
    }
    gameSection = Section(id: "gameSection", cells: cellNode)
    renderer.render(gameSection)
  }
  func getFavourites() -> [Todo]? {
    var todoData = Todo()
    let realm = try! Realm()
    let gameData = realm.objects(Todo.self).toArray() as [Todo]
    return gameData
  }
}
