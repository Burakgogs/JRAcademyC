//
//  ReamEx.swift
//  JRAcademyChallange
//
//  Created by Burak GÖĞÜŞ on 9.06.2023.
//

import Foundation
import RealmSwift

extension RealmCollection {
  func toArray<T>() -> [T] {
    return self.compactMap { $0 as? T }
  }
}
