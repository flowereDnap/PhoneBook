//
//  ContactCore+CoreDataClass.swift
//  Phone Book
//
//  Created by User on 28.02.2022.
//
//

import Foundation
import CoreData

@objc(ContactCore)
public class ContactCore: NSManagedObject{
  
  
  func getMainFields() -> [ContactField] {
      var res:[ContactField] = []
      for el in (mainFieldsCore?.allObjects as? [ContactFieldCore])! {
        res.append(el.transform())
      }
      res.sort { first, second in
        first.position < second.position
      }
      return res
      }
    
  func setMainFields(contactFields:[ContactField],context: NSManagedObjectContext) {
      self.removeFromMainFieldsCore(mainFieldsCore ?? [])
      for el in contactFields {
        self.addToMainFieldsCore(ContactFieldCore(contactField: el, context: context))
      }
  }
  
  func getAdditionalFields()-> [ContactField] {
      var res:[ContactField] = []
      for el in (additionalFieldsCore?.allObjects as? [ContactFieldCore])! {
        res.append(el.transform())
      }
      res.sort { first, second in
        first.position < second.position
      }
      return res
      }
  func setAdditionalFields(contactFields:[ContactField], context: NSManagedObjectContext){
      self.removeFromAdditionalFieldsCore(additionalFieldsCore ?? [])
      for el in contactFields {
        self.addToAdditionalFieldsCore(ContactFieldCore(contactField: el, context: context))
      }
  }
  
  func transform() -> Contact{
    let contact = Contact(mainFields: getMainFields(),
                          additionalFields: getAdditionalFields())
    return contact
  }
  convenience init (contact: Contact, context: NSManagedObjectContext){
    self.init(context: context)
    self.setMainFields(contactFields: contact.mainFields, context: context)
    self.setAdditionalFields(contactFields: contact.additionalFields, context: context)
  }
  convenience init(context: NSManagedObjectContext) {
          self.init(context: context)
      }
}
