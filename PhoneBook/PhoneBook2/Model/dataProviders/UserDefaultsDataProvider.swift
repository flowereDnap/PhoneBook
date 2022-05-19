//
//  UserDefaultsDataProvider.swift
//  PhoneBook2
//
//  Created by User on 08.03.2022.
//

import Foundation

class UserDefaultsDataProvider: DataProvider {

 
  var data: [Contact] = []
  var dataLoad: [Contact] {
    get {
        var data2: [Contact]?
        if let mydata = UserDefaults.standard.value(forKey:DataManager.contactListKey) as? Data {
          data2 = try? PropertyListDecoder().decode(Array<Contact>.self, from: mydata)
        }
        return data2 ?? []
    }
    set {
      UserDefaults.standard.set(try? PropertyListEncoder().encode(newValue), forKey:DataManager.contactListKey)
    }
  }
  
  init() {
    self.data = dataLoad.map{$0.copy()}
  }
  
  
  //MARK: -Contact managment
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
  
}
