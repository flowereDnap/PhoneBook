//
//  ContactFieldCore+CoreDataClass.swift
//  PhoneBook2
//
//  Created by User on 07.03.2022.
//
//

import UIKit
import CoreData



public class ContactFieldCore: NSManagedObject {
  
  
  var type: Types{
    set {
      typeOfValue = newValue.rawValue
    }
    get {
      Types(rawValue: typeOfValue) ?? Types.date
    }
  }
  
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
      case .date:
        valueAsData = withUnsafeBytes(of: (newValue as! Date).timeIntervalSinceReferenceDate) { Data($0) }
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
      case .date:
        return valueAsData.withUnsafeBytes {
            $0.load(as: Int.self)
        }
      }
    }
  }
  
  public init(context: NSManagedObjectContext, contactField: ContactField) {
    let entity = NSEntityDescription.entity(forEntityName: "ContactFieldCore", in: context)!
    super.init(entity: entity, insertInto: context)
    self.lable = contactField.lable
    self.position = Int64(contactField.position)
    self.value = contactField.value
    self.type = contactField.type
  }
  
  public init(context: NSManagedObjectContext,
              position:Int = -1,
              type: Types = .name,
              value: Any? = nil,
              lable: String? = nil) {
    let entity = NSEntityDescription.entity(forEntityName: "ContactFieldCore", in: context)!
    super.init(entity: entity, insertInto: context)
    self.type = type
    if let lable = lable {
      self.lable = lable
    } else {
      self.lable = typeOfValue // typeOfValue it self is a row value of type
    }
    self.value = value
  }
  
  @objc
  override private init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
    super.init(entity: entity, insertInto: context)
  }
}
