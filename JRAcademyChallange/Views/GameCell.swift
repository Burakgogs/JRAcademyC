//
//  HomePageView.swift
//  JRAcademyChallange
//
//  Created by Burak GÖĞÜŞ on 3.06.2023.
//
import Foundation
import SnapKit
import Carbon
import UIKit
import Kingfisher

protocol GameCellDelegate: AnyObject {
  func didSelectGame()
}
struct GameItem: IdentifiableComponent {
  var id: Int
  var name: String
  var metacritic: Int?
  var gameImage: String?
  var genres: String?
  var title: String { name }

  // MARK: - Component
  func render(in content: GameCell) {
    content.gameID = id
    content.gameTitle.text = name
    content.metacritic.text = "metacritic:"
    if let metacritic = metacritic {
      content.metaScore.text = String(metacritic)
    }
    if let genres = genres {
      content.genreTitle.text = genres
    }
    if let gameImage = gameImage, let url = URL(string: gameImage) {
      let resizeProcessor = ResizingImageProcessor(referenceSize: CGSize(width: 120, height: 104))
      let imageLoadingOptions: KingfisherOptionsInfo = [
        .processor(resizeProcessor),
        .scaleFactor(UIScreen.main.scale),
        .transition(.fade(0.2))
      ]
      content.imageView.kf.setImage(with: url, options: imageLoadingOptions)
    }
  }
  func referenceSize(in bounds: CGRect) -> CGSize? {
    return CGSize(width: bounds.width, height: 136)
  }
  func renderContent() -> GameCell {
    return GameCell()
  }
}

final class GameCell: UIView {
  var gameID: Int
  var gameTitle = UILabel()
  var metacritic = UILabel()
  var metaScore = UILabel()
  var genreTitle = UILabel()
  var imageView = UIImageView()
  weak var delegate: GameCellDelegate?

  override init(frame: CGRect) {
    self.gameID = 0
    super.init(frame: frame)
    setupViews()
    setupConstraints()
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageViewTapped))
    self.isUserInteractionEnabled = true
    self.addGestureRecognizer(tapGesture)
  }
  @objc func imageViewTapped() {
    self.delegate?.didSelectGame()
    let gameDetailVC = GameDetailViewController()
    gameDetailVC.getDetailGame(gameID: gameID)
    if let navigationController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController {
      navigationController.pushViewController(gameDetailVC, animated: true)
    }
  }
  func sendDataNotification(gameID: Int) {
    let gameData = gameID
    NotificationCenter.default.post(name: NSNotification.Name("GameDataNotification"), object: gameData)
  }
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  func setupViews() {
    addSubview(gameTitle)
    addSubview(metacritic)
    addSubview(metaScore)
    addSubview(genreTitle)
    addSubview(imageView)

    gameTitle.textColor = .black
    gameTitle.textAlignment = .left
    gameTitle.numberOfLines = 0
    gameTitle.lineBreakMode = .byWordWrapping
    gameTitle.adjustsFontSizeToFitWidth = true
    gameTitle.minimumScaleFactor = 0.5
    gameTitle.baselineAdjustment = .alignBaselines
    gameTitle.font = UIFont(name: "Roboto-Bold", size: 20)

    metacritic.font = UIFont(name: "Roboto-Bold", size: 14)
    metacritic.textColor = .black

    metaScore.font = UIFont(name: "Roboto-Bold", size: 18)
    metaScore.textColor = UIColor(hex: "#D80000")

    genreTitle.font = UIFont.systemFont(ofSize: 13)
    genreTitle.textColor = UIColor(hex: "#8A8A8F")
  }
  func setupConstraints() {
    gameTitle.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(16)
      make.right.equalToSuperview().offset(-16)
      make.left.equalToSuperview().offset(152)
    }
    metacritic.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(84)
      make.right.equalToSuperview().offset(-147)
      make.left.equalToSuperview().offset(152)
    }
    metaScore.snp.makeConstraints { make in
      make.top.equalTo(metacritic)
      make.right.equalToSuperview().offset(-121)
      make.left.equalToSuperview().offset(228)
      make.bottom.equalTo(metacritic)
    }
    genreTitle.snp.makeConstraints { make in
      make.top.equalTo(metacritic.snp.bottom).offset(8)
      make.right.equalToSuperview()
      make.left.equalTo(metacritic.snp.left)
    }
    imageView.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(16)
      make.left.equalToSuperview().offset(16)
      make.right.equalTo(gameTitle.snp.left).offset(-16)
      make.bottom.equalToSuperview().offset(-16)
      make.height.equalTo(104)
      make.width.equalTo(120)
    }
  }
}
extension UIColor {
  convenience init(hex: String) {
    var hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
    if hexString.hasPrefix("#") {
      hexString.remove(at: hexString.startIndex)
    }
    if hexString.count != 6 {
      self.init(white: 1.0, alpha: 1.0)
      return
    }
    var rgbValue: UInt64 = 0
    Scanner(string: hexString).scanHexInt64(&rgbValue)

    let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
    let green = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
    let blue = CGFloat(rgbValue & 0x0000FF) / 255.0
    self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}
