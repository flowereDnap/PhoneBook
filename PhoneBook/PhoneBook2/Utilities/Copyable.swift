//
//  Copyable.swift
//  PhoneBook2
//
//  Created by User on 07.03.2022.
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
