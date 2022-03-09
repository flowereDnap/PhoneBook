//
//  ContactCore+CoreDataClass.swift
//  PhoneBook2
//
//  Created by User on 07.03.2022.
//
//

import Foundation
import CoreData


public class ContactCore: NSManagedObject {
  
  
  
  public init(context: NSManagedObjectContext) {
    let entity = NSEntityDescription.entity(forEntityName: "ContactCore", in: context)!
    super.init(entity: entity, insertInto: context)
    self.id = UUID().uuidString
    self.dateOfCreation = Date()
    let imageField = ContactFieldCore(context: context,
                                      position: 0,
                                      type: .image,
                                      value: nil)
    
    let nameField = ContactFieldCore(context: context,
                                     position: 1,
                                     type: .name,
                                     value: "")
    let numberField = ContactFieldCore(context:context,
                                       position: 2,
                                       type: .number,
                                       value: "")
    self.addToMainFields(imageField)
    self.addToMainFields(nameField)
    self.addToMainFields(numberField)
  }
  
  @objc
  override private init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
    super.init(entity: entity, insertInto: context)
  }
  
  
  
  public init (context: NSManagedObjectContext, contact: Contact){
    let entity = NSEntityDescription.entity(forEntityName: "ContactCore", in: context)!
    super.init(entity: entity, insertInto: context)
    for field in contact.mainFields {
      self.addToMainFields(ContactFieldCore(context: context, contactField: field))
    }
    for field in contact.otherFields {
      self.addToOtherFields(ContactFieldCore(context: context, contactField: field))
    }
    self.id = contact.id
    self.dateOfCreation = contact.dateOfCreation
  }
  
}
