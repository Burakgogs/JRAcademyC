//
//  GameView.swift
//  JRAcademyChallange
//
//  Created by Burak GÖĞÜŞ on 5.06.2023.
//
import UIKit
import SnapKit
import Foundation
import Carbon

class GameView: UIView, Component {
  let labelTitle = UILabel()
  let navigationBar = UINavigationBar()
  let searchBar = UISearchBar()
  let stackView = UIStackView()
  init() {
    super.init(frame: .zero)
    setupViews()
    setupConstraints()
  }
  // MARK: - Component
  func render(in content: GameView) {
    // Burada herhangi bir işlem yapmanıza gerek yok
  }
  func referenceSize(in bounds: CGRect) -> CGSize? {
    return CGSize(width: bounds.width, height: 100) // Replace 64 with the desired height value
  }
  func renderContent() -> GameView {
    return self
  }
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  func setupConstraints() {
    navigationBar.snp.makeConstraints { make in
      make.height.equalTo(140)
      make.width.equalTo(375)
      make.left.equalToSuperview()
      make.top.equalToSuperview()
      make.right.equalToSuperview()
    }
    labelTitle.snp.makeConstraints { make in
      make.top.equalTo(navigationBar).offset(90)
      make.left.equalToSuperview().offset(16)
      make.right.equalToSuperview().offset(250)
      make.bottom.equalTo(navigationBar).offset(-9)
      make.height.equalTo(41)
      make.width.equalTo(109)
    }
    stackView.snp.makeConstraints { make in
      make.top.equalTo(navigationBar.snp.bottom).offset(2)
      make.bottom.equalToSuperview().offset(-83)
      make.leading.equalToSuperview()
      make.trailing.equalToSuperview()
    }
  }

  func setupViews () {
    self.addSubview(navigationBar)
    navigationBar.addSubview(labelTitle)
    self.addSubview(stackView)
    stackView.addArrangedSubview(searchBar)

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
    labelTitle.text = "Games"
    labelTitle.font = UIFont(name: "Roboto-Bold", size: 34)
    stackView.axis = .vertical
    stackView.contentMode = .scaleToFill
    stackView.alignment = .fill
    stackView.spacing = 0
    stackView.distribution = .fill
    stackView.backgroundColor = .gray

    searchBar.backgroundColor = UIColor(red: 248 / 255, green: 248 / 255, blue: 248 / 255, alpha: 0.92)
    searchBar.layer.cornerRadius = 10
    searchBar.placeholder = "Search for the games"
    searchBar.searchTextField.font = UIFont.systemFont(ofSize: 17)
  }
}
