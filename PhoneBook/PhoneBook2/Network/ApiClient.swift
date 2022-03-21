//
//  ApiClient.swift
//  PhoneBook2
//
//  Created by User on 17.03.2022.
//

import Foundation
import FirebaseAuth
import Firebase
import FirebaseFirestoreSwift

enum ApiError: Error {
  case noData
}

class ApiClient: DataProvider{
  
  
  static var user: User?
  
  let db = Firestore.firestore()
  
  var data: [Contact] = []
  
  init() {
    var result: [Contact] = []
    let db = Firestore.firestore()
    guard let uid = ApiClient.user?.uid else {
      debugPrint("user uid is empty")
      data = result
      return
    }
    
    
    db.collection(uid).getDocuments { (querySnapshot, error) in
      guard let snapshotDocuments = querySnapshot?.documents else {
        print("case 0")
        return
      }
      print("case 1")
      for document in snapshotDocuments {
        print("case 2")
        do {
          let contact = try document.data(as: Contact.self)
          print("cont: ", contact.id)
          result.append(contact)
        } catch let error as NSError {
          debugPrint("error: \(error.localizedDescription)")
        }
      }
      print("case 3")
      self.data = result
    }
  }
  
  func save() {
    for contact in data {
      updContact(contact: contact)
    }
  }
  
  func addContact() -> Contact {
    let newContact = Contact()
    updContact(contact: newContact)
    data.append(newContact)
    return newContact
  }
  
  func updContact(contact: Contact) {
    guard let uid = ApiClient.user?.uid else {
      debugPrint("user.uid is empty")
      return
    }
    do {
      try db.collection(uid).document(contact.id).setData(from: contact)
    } catch let error {
      debugPrint("Error writing city to Firestore: \(error)")
    }
    
    let changingContact = data.first{$0.id == contact.id}
    changingContact?.mainFields = contact.mainFields
    changingContact?.otherFields = contact.otherFields
  }
  
  func deleteContact(id: String) {
    guard let uid = ApiClient.user?.uid else {
      debugPrint("user.uid is empty")
      return
    }
    db.collection(uid).document(id).delete() { err in
      if let err = err {
        debugPrint("Error removing document: \(err)")
      }
    }
    
    if let index = data.firstIndex(where:  {$0.id == id}) {
      data.remove(at: index)
    }
  }
}
