//
//  ContactItem.swift
//  Phone Book
//
//  Created by User on 22.02.2022.
//

import UIKit

protocol ContactFieldProtocol: Codable, Hashable {
  var lable:String? {get set}
  var type: Labels { get }
  var value: ContactFieldValue? {get set}
  var position: Int{get set}
  var toShow: Bool {get}
  mutating func move(back:Bool)
}

public struct ContactField: Codable, Hashable, ContactFieldProtocol{
  var lable:String?
  let type: Labels
  var value: ContactFieldValue?
  var position: Int = -1
  init (lable: String?, type: Labels, position:Int = -1, value: ContactFieldValue?){
    self.lable = lable
    self.position = position
    self.value = value
    self.type = type
  }
  var toShow: Bool {
    switch type {
    case .id:
      return false
    case .name:
      return true
    case .number:
      return true
    case .dateOfCreation:
      return false
    case .image:
      return true
    case .mail:
      return true
    case .dateOfBirth:
      return true
    }
  }
  
  mutating func move(back:Bool = false){
    if back {
      position = position - 1
    } else {
      position = position + 1
    }
  }
}




public enum ContactFieldValue:  Codable , Hashable{
  case id(String) 
  case name(String)
  case number(String)
  case mail(String)
  case date(Date)
  case image(ImageWrapper)
  
}

enum Labels:String, Codable, Hashable{
  case id = "id"
  case name
  case number
  case dateOfCreation = "date of creation"
  case image
  case mail
  case dateOfBirth = "date of birth"
  
}

extension ContactFieldValue {
  func getEmbeddedValue() -> Any{
    if case let .id(value) = self{
      return value
    }
    if case let .name(value) = self{
      return value
    }
    if case let .number(value) = self{
      return value
    }
    if case let .mail(value) = self{
      return value
    }
    if case let .image(value) = self{
      return value
    }
    if case let .date(value) = self{
      return value
    }
    return 0
  }
}

