//
//  UserDefaultsDataProvider.swift
//  PhoneBook2
//
//  Created by User on 08.03.2022.
//

import Foundation

class UserDefaultsDataProvider: DataProvider {
  func updContact(contact: Contact) {
    let changingContact = data.first{$0.id == contact.id}
    changingContact?.mainFields = contact.mainFields
    changingContact?.otherFields = contact.otherFields
  }
  
  func addContact() -> Contact {
    let newContact = Contact()
    data.append(newContact)
    save()
    return newContact
  }
  
  func save() {
    self.dataLoad = self.data
  }
  
  
  func deleteContact(id: String) {
    if let index = data.firstIndex(where:  {$0.id == id}) {
      data.remove(at: index)
      save()
    }
  }
  
  private var loaded_data: [Contact] = []
  var data: [Contact] = []
  var dataLoad: [Contact] {
    get {
      if !loaded_data.isEmpty {
        return loaded_data
      }
      else {
        var data2: [Contact]?
        if let mydata = UserDefaults.standard.value(forKey:DataManager.contactListKey) as? Data {
          data2 = try? PropertyListDecoder().decode(Array<Contact>.self, from: mydata)
        }
        loaded_data = data2 ?? []
        return loaded_data
      }
    }
    set {
      loaded_data = newValue
      UserDefaults.standard.set(try? PropertyListEncoder().encode(newValue), forKey:DataManager.contactListKey)
    }
  }
  
  var count: Int {
    return loaded_data.count
  }
  
  init() {
    self.data = dataLoad
  }
  //MARK: -Contact managment
  
  
  
  /*func addContact(contact: Contact) {
    loaded_data.append(contact)
    save()
  }
  
  func getContact(Id: String) -> Contact {
    return loaded_data[loaded_data.firstIndex(where: { (($0.mainFields.first(where: {$0.type == .id})?.value?.getEmbeddedValue())! as! String) == Id
    })!]
  }
  
  func updContact(Id: String, mainFields: [ContactField]? = nil , additionalFields:[ContactField]?) {
    
    if let mainFields = mainFields {
      getContact(Id: Id).mainFields = mainFields
    }
    if let additionalFields = additionalFields {
      getContact(Id: Id).additionalFields = additionalFields
    }
    save()
  }
  
  
  func deleteContact(Id: String) {
    
    loaded_data.remove(at: loaded_data.firstIndex(where: { (($0.mainFields.first(where: {$0.type == .id})?.value?.getEmbeddedValue())! as! String) == Id
    })!)
    save()
  }
  
  //upd of model
  func save() {
    allContacts = loaded_data
  }
  */
  
}
