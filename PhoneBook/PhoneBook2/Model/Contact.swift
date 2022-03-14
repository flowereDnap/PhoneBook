//
//  Contact.swift
//  PhoneBook2
//
//  Created by User on 07.03.2022.
//

import UIKit

public class Contact: Codable, Copyable{
  
  private enum CodingKeys: String, CodingKey {
    case id, dateOfCreation, mainFields, otherFields
  }
  
  let id: String
  let dateOfCreation: Date
  var mainFields: [ContactField] = []
  var otherFields: [ContactField] = []
  var searchFoundIn: NSAttributedString?
  
  func getPositionOfLast(inMainFields:Bool, type: Types)->Int{
    if inMainFields{
      //if fields of type exist get last
      guard let result: Int = self.mainFields.last(where: {$0.type == type})?.position else {
        //if previous type exists
        if let newType = type.getPrev() {
          return getPositionOfLast(inMainFields: true, type: newType)
        } else {
          //there is no cells return 0
          return 0
        }
      }
      return result
    } else {
      guard let result: Int = self.otherFields.last(where: {$0.type == type})?.position else {
        if let newType = type.getPrev() {
          return getPositionOfLast(inMainFields: false, type: newType)
        } else {
          return 0
        }
      }
      return result
    }
  }
  
  func sort (){
    self.mainFields.sort { first, second in
      first.position < second.position
    }
    self.otherFields.sort { first, second in
      first.position < second.position
    }
  }
  
  init(mainFields:[ContactField]? = nil, otherFields: [ContactField]? = nil) {
    self.id = UUID().uuidString
    self.dateOfCreation = Date()
    if let mainFields = mainFields {
      self.mainFields = mainFields
    } else {
      let imageField = ContactField(position: 0,
                                    type: .image,
                                    value: nil)
      let nameField = ContactField(position: 1,
                                   type: .name,
                                   value: "")
      let numberField = ContactField(position: 2,
                                     type: .number,
                                     value: "")
      self.mainFields.append(imageField)
      self.mainFields.append(nameField)
      self.mainFields.append(numberField)
    }
    if let otherFields = otherFields {
      self.otherFields = otherFields
    }
  }
  
  init(coreContact: ContactCore) {
    for field in coreContact.mainFields?.allObjects as! [ContactFieldCore] {
      self.mainFields.append(ContactField(contactFieldCore: field))
    }
    for field in coreContact.otherFields?.allObjects as! [ContactFieldCore] {
      self.otherFields.append(ContactField(contactFieldCore: field))
    }
    self.id = coreContact.id
    self.dateOfCreation = coreContact.dateOfCreation
  }
  
  required init(instance: Contact) {
   self.id = instance.id
   self.dateOfCreation = instance.dateOfCreation
    for field in instance.mainFields {
      self.mainFields.append(field.copy())
    }
    for field in instance.otherFields {
      self.otherFields.append(field.copy())
    }
 }
}


