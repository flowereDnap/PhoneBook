//
//  UserDefaultsDataProvide.swift
//  Phone Book
//
//  Created by User on 22.02.2022.
//

import Foundation

class UserDefaultsDataProvide: ContactsDataProtocol {
  
  var id: String = {
    return UUID().uuidString
  }()
  private var loaded_data: [Contact] = []
  var allContacts: [Contact] {
    get {
      
      if !loaded_data.isEmpty {
        return loaded_data
      }
      else {
        var data2: [Contact]?
        if let mydata = UserDefaults.standard.value(forKey:Model.contactListKey) as? Data {
          data2 = try? PropertyListDecoder().decode(Array<Contact>.self, from: mydata)
        }
        loaded_data = data2 ?? []
        return loaded_data
      }
    }
    set {
      loaded_data = newValue
      UserDefaults.standard.set(try? PropertyListEncoder().encode(newValue), forKey:Model.contactListKey)
    }
  }
  
  var count: Int {
    return loaded_data.count
  }
  
 
  //MARK: -Contact managment
  func addContact(contact: Contact) {
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
  
  
}
