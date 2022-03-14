//
//  TypesOfContactField.swift
//  PhoneBook2
//
//  Created by User on 07.03.2022.
//


import UIKit

public enum Types: String , Codable{
  case image
  case name
  case number
  case date
  
  func getPrev()->Types?{
    switch self {
    case .image:
      return nil
    case .name:
      return .image
    case .number:
      return .name
    case .date:
      return nil
    }
  }
  
  func defaultValue()->Any{
    switch self {
    case .image:
      return UIImage(named: "contactDefaultImage")!
    case .name:
      return ""
    case .number:
      return ""
    case .date:
      return Date()
    }
  }
}

