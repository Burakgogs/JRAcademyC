//
//  ToDoDataModel.swift
//  JRAcademyChallange
//
//  Created by Burak GÖĞÜŞ on 9.06.2023.
//

import Foundation
import RealmSwift

class Todo: Object {
  @Persisted var gameid: Int = 0
  @Persisted var name: String = ""
  @Persisted var image: String? = ""
  @Persisted var metacritic: Int? = 0
  @Persisted var genres: String? = ""
}
