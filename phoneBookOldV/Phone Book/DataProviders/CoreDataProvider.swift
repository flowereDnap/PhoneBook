//
//  CoreDataProvider.swift
//  Phone Book
//
//  Created by User on 22.02.2022.
//

import Foundation
import UIKit
import CoreData

class CoreDataProvider: ContactsDataProtocol {
  
  
  
  let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
  var model: ModelCore
  
  
  var allContacts: [Contact] {
    get{
      let coreContacts = model.contacts?.allObjects as! [ContactCore]
      var res:[Contact] = []
      for el in coreContacts {
        res.append(el.transform())
      }
      return res
    }
    set{
    
      let contToRemove:NSSet = model.contacts ?? []
 
      model.removeFromContacts(contToRemove)
   
      for cont in newValue {
        let contactToAdd = ContactCore(contact: cont, context: context)
        model.addToContacts(contactToAdd)
 
      }

    }
  }
  
  var id: String = {
    return UUID().uuidString
  }()
  init(){
    print("init core")
    do {
      self.model = (try context.fetch(ModelCore.fetchRequest())).first ?? ModelCore(context: context)

      try context.save()
    } catch {
      self.model = ModelCore(context: context)
      print("model load from core fail")
    }
  }
  
  var count: Int  {
    return model.contacts?.count ?? 0
  }
  
  func addContact(contact: Contact) {
    let contactCore = ContactCore(context: context)
    contactCore.setMainFields(contactFields: contact.mainFields, context: context)
    contactCore.setAdditionalFields(contactFields: contact.additionalFields, context: context)
    self.model.addToContacts(contactCore)
    save()
  }
  
  func getContactCore(Id: String) -> ContactCore {
    return (model.contacts?.filter{
      ((($0 as! ContactCore).getMainFields().first(where: {$0.type == .id})?.value?.getEmbeddedValue() as! String) == Id)
    }.first as! ContactCore)
  }
  
  func getContact(Id: String) -> Contact {
    return getContactCore(Id: Id).transform()
  }
  
  func updContact(Id: String, mainFields: [ContactField]?, additionalFields: [ContactField]?) {
    if let mainFields = mainFields {
      getContactCore(Id: Id).setMainFields(contactFields: mainFields, context: context)
    }
    if let additionalFields = additionalFields {
      getContactCore(Id: Id).setAdditionalFields(contactFields: additionalFields, context: context)
    }
    save()
  }
  
  func deleteContact(Id: String) {
    let contactToRemove = getContactCore(Id: Id)
    context.delete(contactToRemove)
    save()
  }
  
  func save() {
    do {
      try context.save()
    } catch {
      print("core data save failed")
    }
  }
}

/*class CoreDataManager {
 static let shared = CoreDataManager()
 private init() {}
 private lazy var persistentContainer: NSPersistentContainer = {
 let container = NSPersistentContainer(name: "Contacts")
 container.loadPersistentStores(completionHandler: { _, error in
 _ = error.map { fatalError("Unresolved error \($0)") }
 })
 return container
 }()
 
 var mainContext: NSManagedObjectContext {
 return persistentContainer.viewContext
 }
 
 func backgroundContext() -> NSManagedObjectContext {
 return persistentContainer.newBackgroundContext()
 }
 }
 */
