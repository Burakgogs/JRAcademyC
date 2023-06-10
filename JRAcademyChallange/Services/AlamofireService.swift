//
//  AlamofireService.swift
//  JRAcademyChallange
//
//  Created by Burak GÖĞÜŞ on 3.06.2023.
//
import Alamofire

struct AlamofireService {
  static let shared = AlamofireService()

  func getDefaultRequest(url: String, method: HTTPMethod, params: [String: AnyObject] = [:]) -> URLRequest {
    guard let url = URL(string: url) else {
      fatalError("Invalid URL: \(url)")
    }
    var request = URLRequest(url: url)
    request.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
    request.timeoutInterval = 120.0
    request.method = method
    if !params.isEmpty {
      request.httpBody = try? JSONSerialization.data(withJSONObject: params)
    }
    return request
  }

  func getUrlComponent() -> URLComponents {
    var urlComponents = URLComponents()
    urlComponents.scheme = "https"
    urlComponents.host = "api.rawg.io"
    urlComponents.path = "/api/games"
    urlComponents.queryItems = [URLQueryItem(name: "key", value: "99754714091e4d8d82257b2bd4825d84")]
    return urlComponents
  }
  func requestGetGames(completion: @escaping (Result<([Game], String?), Error>) -> Void) {
    if let url = getUrlComponent().url?.absoluteString {
      let request = self.getDefaultRequest(url: url, method: .get)
      AF.request(request).responseDecodable(of: GameResponse.self) { response in
        switch response.result {
        case .success(let gameResponse):
          completion(
            .success(( gameResponse.results, gameResponse.next ))
          )
        case .failure(let error):
          completion(.failure(error))
        }
      }
    }
  }
  func requestGetGamesWithSearch(searchText: String, completion: @escaping (Result<[Game], Error>) -> Void) {
    var urlComponents = getUrlComponent()
    let searchQuery = URLQueryItem(name: "search", value: searchText)
    urlComponents.queryItems?.append(searchQuery)
    guard let url = urlComponents.url else {return}
    let request = self.getDefaultRequest(url: url.absoluteString, method: .get)
    AF.request(request).responseDecodable(of: GameResponse.self) { response in
      switch response.result {
      case .success(let gameResponse):
        completion(.success(gameResponse.results))
      case .failure(let error):
        completion(.failure(error))
      }
    }
  }
  func requestGetGamesDetail(gameID: Int, completion: @escaping (Result<GameDetail, Error>) -> Void) {
    var urlComponents = URLComponents()
    urlComponents.scheme = "https"
    urlComponents.host = "api.rawg.io"
    urlComponents.path = "/api/games/\(gameID)"
    urlComponents.queryItems = [URLQueryItem(name: "key", value: "99754714091e4d8d82257b2bd4825d84")]
    guard let url = urlComponents.url else {
      // Handle error
      return
    }
    let request = self.getDefaultRequest(url: url.absoluteString, method: .get)
    AF.request(request).responseDecodable(of: GameDetail.self) { response in
      switch response.result {
      case .success(let gameDetailResponse):
        completion(.success(gameDetailResponse))
      case .failure(let error):
        completion(.failure(error))
      }
    }
  }
  func requestGetMoreGames(nextPage: String?, completion: @escaping (Result<([Game], String?), Error>) -> Void) {
    if let nextPage = nextPage {
      let request = self.getDefaultRequest(url: nextPage, method: .get)
      AF.request(request).responseDecodable(of: GameResponse.self) { response in
        switch response.result {
        case .success(let gameResponse):
          completion(.success((gameResponse.results, gameResponse.next)))
        case .failure(let error):
          completion(.failure(error))
        }
      }
    } else {
      print("Error")
    }
  }
}
