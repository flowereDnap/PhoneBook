//
//  CoreDataProvider.swift
//  PhoneBook2
//
//  Created by User on 08.03.2022.
//

import Foundation
import UIKit

class CoreDataProvider: DataProvider {
 
  
  let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
  var loadDataCore: [ContactCore]!
  var loadData: [Contact] = []
  var data: [Contact] {
    get {
      return loadData
    }
    set {
      loadData = newValue
    }
  }
  
  init(){
    fetch()
  }
  
  func fetch(){
    do{
      loadDataCore = try context.fetch(ContactCore.fetchRequest())
    } catch {
      
    }
    loadData = []
    for coreContact in loadDataCore {
      loadData.append(Contact(coreContact: coreContact))
    }
  }
  
  func save() {
    do {
      try context.save()
    } catch {
      
    }
    fetch()
  }
  
  func addContact() -> Contact {
    let newCoreContact = ContactCore(context: context)
    save()
    return Contact(coreContact: newCoreContact)
  }
  
  func updContact(contact: Contact) {
    /*let contactToUpd = loadDataCore.first{$0.id == contact.id}
    contactToUpd?.mainFields = contact.mainFields
    contactToUpd?.otherFields = contact.mainFields ?????????
     */
    //idk if its optimal
    
    //order matters
    deleteContact(id: contact.id)
    
    ContactCore(context: context, contact: contact)
    save()
  }
  
  func deleteContact(id: String) {
    let contactToDel = loadDataCore.first{$0.id == id}!
    context.delete(contactToDel)
    save()
  }
  
  
}
