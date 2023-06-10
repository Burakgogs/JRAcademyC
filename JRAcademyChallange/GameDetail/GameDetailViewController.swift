//
//  GameDetailViewController.swift
//  JRAcademyChallange
//
//  Created by Burak GÖĞÜŞ on 6.06.2023.
//

import UIKit
import Foundation
import Carbon
import CoreData
import RealmSwift

class GameDetailViewController: UIViewController, GameViewModelDelegate, UISearchBarDelegate {
  weak var favouritesController: FavouritesViewController?
  func getDetailGames() {
    render()
    checkFavourites()
  }
  func didFetchMoreGames() {}
  func searchGame() {}
  func didFetchGames() {}
  private let tableView = UITableView()
  var viewModel = GameViewModel()
  var gameID: Int?
  var managedObjectContext: NSManagedObjectContext!
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    viewModel.delegate = self
    tableView.isScrollEnabled = false
    renderer.target = tableView
    configureTableView()
  }
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
  }
  func checkFavourites() {
    let favoriteButton = UIBarButtonItem(
      title: "Favourite",
      style: .plain,
      target: self,
      action: #selector(favouriteButtonTapped)
    )
    navigationItem.rightBarButtonItem = favoriteButton
    do {
      let realm = try Realm()
      if let gameid = viewModel.gamesDetail?.id {
        let results = realm.objects(Todo.self).filter { $0.gameid == gameid }
        if !results.isEmpty {
          navigationItem.rightBarButtonItem?.title = "Favourited"
          navigationItem.rightBarButtonItem?.isHidden = true
          favouritesController?.favCount += 1
        } else {
          navigationItem.rightBarButtonItem?.isHidden = false
        }
      }
    } catch let error {
      // Hata işleme
      print("Hata oluştu: \(error)")
    }
  }

  @objc func favouriteButtonTapped() {
    do {
      let realm = try Realm()
      let data = Todo()
      var combinedGenres: String?
      if let genres = viewModel.gamesDetail?.genres {
        let genreNames = genres.compactMap { $0.name }
        combinedGenres = genreNames.joined(separator: ", ")
      }
      if let gamesDetail = viewModel.gamesDetail {
        data.gameid = gamesDetail.id
        data.name = gamesDetail.name
        data.image = gamesDetail.backgroundImage
        data.metacritic = gamesDetail.metacritic
        data.genres = combinedGenres
      }
      try realm.write {
        realm.add(data)
        navigationItem.rightBarButtonItem?.title = "Favourited"
        NotificationCenter.default.post(name: NSNotification.Name("getMoreGame"), object: nil)
      }
    } catch let error {
      // Hata işleme
      print("Hata oluştu: \(error)")
    }
  }

  func getDetailGame(gameID: Int) {
    viewModel.getDetailGames(gameID: gameID)
  }
  private let renderer = Renderer(
    adapter: UITableViewAdapter(),
    updater: UITableViewUpdater()
  )
  func render() {
    var cellNode: [CellNode] = []
    let gameDetailNode = CellNode(
      GameDetailItem(
        gameDetail: GameDetail(
          id: viewModel.gamesDetail?.id ?? 0,
          name: viewModel.gamesDetail?.name ?? "",
          backgroundImage: viewModel.gamesDetail?.backgroundImage ?? "",
          description: viewModel.gamesDetail?.description ?? "",
          redditUrl: viewModel.gamesDetail?.redditUrl ?? "",
          website: viewModel.gamesDetail?.website ?? "",
          genres: viewModel.gamesDetail?.genres ?? [],
          metacritic: viewModel.gamesDetail?.metacritic ?? 0
        )
      )
    )
    cellNode.append(gameDetailNode)
    let gameSection = Section(id: "gameSection", cells: cellNode)
    renderer.render(gameSection)
  }
  func configureTableView() {
    view.addSubview(tableView)
    tableView.snp.makeConstraints { make in
      make.top.equalTo(0)
      make.leading.equalTo(0)
      make.trailing.equalTo(0)
      make.bottom.equalToSuperview().offset(0)
    }
    tableView.separatorStyle = .none
    tableView.contentInset = UIEdgeInsets(top: -20, left: 0, bottom: 0, right: 0)
  }
}
