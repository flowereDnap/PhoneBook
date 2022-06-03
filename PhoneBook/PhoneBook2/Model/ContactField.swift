//
//  ContactField.swift
//  PhoneBook2
//
//  Created by User on 07.03.2022.
//

import UIKit


public class ContactField: Codable, Copyable{
 
  
  private enum CodingKeys: String, CodingKey {
          case position
          case type
          case lable
          case valueAsData
      }
  
  var position: Int
  var type: Types = .name
  var lable: String
  var value: Any? {
    set {
      let value: Any = newValue ?? type.defaultValue()
      switch type {
      case .image:
        valueAsData = (value as! UIImage).pngData()!
      case .name:
        valueAsData = Data((value as! String).utf8)
      case .number:
        valueAsData = Data((value as! String).utf8)
      case .email:
        valueAsData = Data((value as! String).utf8)
      }
    }
    get {
      switch type {
      case .name:
        return String(decoding: valueAsData, as: UTF8.self)
      case .number:
        return String(decoding: valueAsData, as: UTF8.self)
      case .image:
        return UIImage(data: valueAsData)
      case .email:
        return String(decoding: valueAsData, as: UTF8.self)
      }
  }
  }
  var valueAsData: Data!
  
  func isMain()->Bool {
    switch self.type{
    case .image:
      return true
    case .name:
      return true
    case .number:
      return true
    case .email:
      return false
    }
  }
  
  init(position:Int = -1, type: Types, lable: String? = nil, value: Any?) {
    self.position = position
    self.type = type
    if let lable = lable {
      self.lable = lable
    } else {
      self.lable = type.rawValue
    }
    self.value = value
  }
  init(contactFieldCore: ContactFieldCore) {
    self.lable = contactFieldCore.lable
    self.position = Int(contactFieldCore.position)
    self.type = contactFieldCore.type
    self.value = contactFieldCore.value
    
  }
  
  required init(instance: ContactField) {
    self.type = instance.type
    self.valueAsData = instance.valueAsData
    self.position = instance.position
    self.lable = instance.lable
  }
  
}

