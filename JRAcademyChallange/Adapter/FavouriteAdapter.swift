//
//  FavouriteAdapter.swift
//  JRAcademyChallange
//
//  Created by Burak GÖĞÜŞ on 8.06.2023.
//

import Foundation
import UIKit
import Carbon
import CoreData
import RealmSwift
class FavouriteAdapter: UITableViewAdapter {
  weak var favouritesController: FavouritesViewController?
  func tableView(_ tableView: UITableView, canFocusRowAt indexPath: IndexPath) -> Bool {
    return true
  }

  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    let alertController = UIAlertController(
      title: "Onay",
      message: "Silmek istediğinizden emin misiniz?",
      preferredStyle: .alert
    )
    let confirmAction = UIAlertAction(title: "Evet", style: .default) { ( _ ) in
      do {
        let realm = try Realm()
        if let gameid = self.favouritesController?.favouritesGames[indexPath.row] {
          let results = realm.objects(Todo.self).filter {
            $0.gameid == gameid
          }

          if let objectToDelete = results.first {
            try realm.write {
              realm.delete(objectToDelete)
            }
          }
        }
        self.favouritesController?.favCount -= 1
        self.favouritesController?.render()
      } catch let error {
        print("Hata oluştu: \(error)")
      }
    }
    alertController.addAction(confirmAction)
    let cancelAction = UIAlertAction(title: "İptal", style: .cancel) { ( _ ) in
      // Kullanıcı iptal ettiğinde yapılması gereken işlemler burada yer alır
      print("İşlem iptal edildi")
    }
    alertController.addAction(cancelAction)
    UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
  }
}
