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
  case email
  
  func getPrev()->Types?{
    switch self {
    case .image:
      return nil
    case .name:
      return .image
    case .number:
      return .name
    case .email:
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
    case .email:
      return "" 
    }
  }
}

