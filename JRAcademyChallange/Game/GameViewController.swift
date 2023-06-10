//
//  GameViewController.swift
//  JRAcademyChallange
//
//  Created by Burak GÖĞÜŞ on 4.06.2023.
//
import UIKit
import Foundation
import Carbon
class GameViewController: UIViewController, GameViewModelDelegate, UISearchBarDelegate {
  func getDetailGames() {}
  func didFetchMoreGames() {
    render()
  }
  func searchGame() {
    render()
  }
  func didFetchGames() {
    render()
  }
  private let tableView = UITableView()
  var viewModel = GameViewModel()
  let gameView = GameView()
  var isTypingAllowed = true
  var cell = GameCell()
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    view.addSubview(gameView)
    gameView.snp.makeConstraints { make in
      make.top.equalTo(0)
      make.leading.trailing.equalTo(0)
      make.height.equalTo(gameView.snp.height)
    }
    viewModel.delegate = self
    viewModel.fetchGames()
    renderer.target = tableView
    configureTableView()
    gameView.searchBar.delegate = self
    NotificationCenter.default
      .addObserver(
        self,
        selector: #selector(getNextPage(notification:)),
        name: NSNotification.Name("getMoreGame"),
        object: nil
      )
  }
  @objc func getNextPage(notification: Notification) {
    if let nextPage = viewModel.nextPage {
      if !viewModel.games.isEmpty {
        viewModel.fetchMoreGames(nextPage: nextPage)
      }
    }
  }
  private let renderer = Renderer(
    adapter: CustomTableViewAdapter(),
    updater: UITableViewUpdater()
  )
  func render() {
    var cellNode: [CellNode] = []
    if viewModel.games.isEmpty {
      let emptyNode = CellNode(id: "EmptyCell", EmptyItem())
      cellNode.append(emptyNode)
    } else {
      for game in viewModel.games {
        if let genres = game.genres {
          let genreNames = genres.compactMap { $0.name }
          if !genreNames.isEmpty {
            let joinedGenreNames = genreNames.joined(separator: ", ")
            let gameNode = CellNode(
              id: "GameCell",
              GameItem(
                id: game.id,
                name: game.name,
                metacritic: game.metacritic,
                gameImage: game.gameImage,
                genres: joinedGenreNames
              )
            )
            cellNode.append(gameNode)
          }
        }
      }
    }
    if viewModel.games.count > 5 {
      tableView.tableFooterView = LoadingCell(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 60))
    } else {
      tableView.tableFooterView = nil
    }
    let gameSection = Section(id: "gameSection", cells: cellNode)
    renderer.render(gameSection)
  }
  func configureTableView() {
    view.addSubview(tableView)
    tableView.snp.makeConstraints { make in
      make.top.equalTo(gameView.searchBar.snp.bottom)
      make.leading.equalTo(0)
      make.trailing.equalTo(0)
      make.bottom.equalToSuperview().offset(-83)
    }
    tableView.separatorStyle = .none
    tableView.contentInset = UIEdgeInsets(top: -20, left: 0, bottom: 0, right: 0)
  }
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    viewModel.games.removeAll()
    if let searchText = searchBar.text {
      if searchText.count >= 3 {
        viewModel.searchGames(text: searchText)
      }
    }
    searchBar.resignFirstResponder()
  }
  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    searchBar.text = ""
    searchBar.resignFirstResponder()
    searchBar.showsCancelButton = false
    viewModel.games.removeAll()
    viewModel.fetchGames()
    didFetchGames()
  }
  func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
    searchBar.showsCancelButton = true
    viewModel.games.removeAll()
    render()
  }
  func searchbar(_ searchBar: UISearchBar) {
    viewModel.games.removeAll()
    render()
    searchBar.resignFirstResponder()
  }
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    viewModel.games.removeAll()
    if !isTypingAllowed {
      searchBar.text = searchText
      if searchText.count >= 3 {
        viewModel.searchGames(text: searchText)
      }
    }
  }
  func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
    if !isTypingAllowed {
      return false
    }
    isTypingAllowed = false
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
      self.isTypingAllowed = true
    }
    return true
  }
}
