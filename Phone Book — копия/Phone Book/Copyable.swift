//
//  Copyable.swift
//  Phone Book
//
//  Created by User on 22.02.2022.
//

import Foundation

protocol Copyable {
  init(instance: Self)
}

extension Copyable {
  func copy() -> Self {
    return Self.init(instance: self)
  }
}
