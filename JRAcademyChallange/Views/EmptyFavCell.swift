//
//  EmptyFavCell.swift
//  JRAcademyChallange
//
//  Created by Burak GÖĞÜŞ on 9.06.2023.
//
import Foundation
import SnapKit
import Carbon
import UIKit

struct EmptyFavItem: IdentifiableComponent {
  var id = 1
  // MARK: - Component
  func render(in content: EmptyFavCell) {}
  func referenceSize(in bounds: CGRect) -> CGSize? {
    return CGSize(width: bounds.width, height: 136) // Replace 64 with the desired height value
  }
  func renderContent() -> EmptyFavCell {
    return EmptyFavCell()
  }
}
final class EmptyFavCell: UIView {
  var emptyTitle = UILabel()
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupViews()
    setupConstraints()
  }
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  func setupViews () {
    self.addSubview(emptyTitle)

    emptyTitle.textColor = .black
    emptyTitle.textAlignment = .center
    emptyTitle.numberOfLines = 0
    emptyTitle.lineBreakMode = .byWordWrapping
    emptyTitle.textColor = .black
    emptyTitle.adjustsFontSizeToFitWidth = true
    emptyTitle.minimumScaleFactor = 0.5
    emptyTitle.baselineAdjustment = .alignCenters
    emptyTitle.text = "There is no favourites found."
    emptyTitle.font = UIFont(name: "Roboto-Bold", size: 18)
  }
  func setupConstraints() {
    emptyTitle.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(37.5)
      make.centerX.equalToSuperview()
    }
  }
}
