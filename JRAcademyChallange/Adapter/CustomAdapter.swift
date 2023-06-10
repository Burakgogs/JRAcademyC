//
//  CustomAdapter.swift
//  JRAcademyChallange
//
//  Created by Burak GÖĞÜŞ on 8.06.2023.
//


import Carbon
class CustomTableViewAdapter: UITableViewAdapter {
  var isLast = false

  override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    let lastSectionIndex = tableView.numberOfSections - 1
    let lastRowIndex = tableView.numberOfRows(inSection: lastSectionIndex) - 1
    if indexPath.section == lastSectionIndex && indexPath.row == lastRowIndex {
    NotificationCenter.default.post(name: NSNotification.Name("getMoreGame"), object: nil)
    }
  }
}
