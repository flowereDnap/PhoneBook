//
//  ContactFieldCore+CoreDataClass.swift
//  Phone Book
//
//  Created by User on 28.02.2022.
//
//

import Foundation
import CoreData

@objc(ContactFieldCore)
public class ContactFieldCore: NSManagedObject {
  var type: Labels {
    set {
      typeCore = newValue.rawValue
    }
    get {
      Labels(rawValue: typeCore!) ?? Labels.id
    }
  }
  
  private var valueTypeCasted: ValueType{
    set {
      valueType = newValue.rawValue
    }
    get {
      ValueType(rawValue: valueType!) ?? ValueType.id
    }
  }
  
  var value: ContactFieldValue {
    get{
      switch valueTypeCasted {
      case .id:
        return ContactFieldValue.id(valueCore as! String)
      case .name:
        return ContactFieldValue.name(valueCore as! String)
      case .number:
        return ContactFieldValue.number(valueCore as! String)
      case .mail:
        return ContactFieldValue.mail(valueCore as! String)
      case .date:
        return ContactFieldValue.date(valueCore as! Date)
      case .image:
        return ContactFieldValue.image(valueCore as! ImageWrapper)
      }
    }
    set{
      switch valueTypeCasted {
      case .id:
        if case let ContactFieldValue.id(value) = newValue {
          valueCore = value as NSObject
        }
      case .name:
        if case let ContactFieldValue.name(value) = newValue {
          valueCore = value as NSObject
        }
      case .number:
        if case let ContactFieldValue.number(value) = newValue {
          valueCore = value as NSObject
        }
      case .mail:
        if case let ContactFieldValue.mail(value) = newValue {
          valueCore = value as NSObject
        }
      case .date:
        if case let ContactFieldValue.date(value) = newValue {
          valueCore = value as NSObject
        }
      case .image:
        if case let ContactFieldValue.image(value) = newValue {
          valueCore = value as NSObject
        }
      }
    }
  }
  
  enum ValueType: String {
    case id
    case name
    case number
    case mail
    case date
    case image
  }
  func transform() -> ContactField {
    let contactField = ContactField(lable: lable,
                                    type: type,
                                    position: Int(position),
                                    value: value)
    return contactField
  }
  convenience init(contactField: ContactField, context: NSManagedObjectContext){
    self.init(context: context)
    self.lable = contactField.lable
    self.value = contactField.value!
    self.type = contactField.type
    self.position = Int64(contactField.position)
  }
  
  convenience init(context: NSManagedObjectContext) {
          self.init(context: context)
      }
}
