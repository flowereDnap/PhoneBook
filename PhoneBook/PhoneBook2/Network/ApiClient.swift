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
  static var parentView: ViewController!
  
  let loadingVC = LoadingViewController()

  
  var gotAnswer: Bool! {
    didSet {
      if self.gotAnswer == true {
        ApiClient.parentView.dismiss(animated: true, completion: nil)
        ApiClient.parentView.reloadTableViewData(with: "")
      } else {
        ApiClient.parentView.present(loadingVC, animated: true, completion: nil)
      }
    }
  }
  
  let db = Firestore.firestore()
  
  var data: [Contact] = []
  
  init() {
    
    loadingVC.modalPresentationStyle = .overCurrentContext
    loadingVC.modalTransitionStyle = .crossDissolve
   
    callfunc()
    var result: [Contact] = []
    let db = Firestore.firestore()
    guard let uid = ApiClient.user?.uid else {
      debugPrint("user uid is empty")
      data = result
      self.gotAnswer = true
      return
    }
    
    
    db.collection(uid).getDocuments { (querySnapshot, error) in
      if let err = error {
        self.gotAnswer = true
        ApiClient.parentView.showToast(message: err.localizedDescription)
      }
      
      
      guard let snapshotDocuments = querySnapshot?.documents else {
        self.gotAnswer = true
        return
      }
      for document in snapshotDocuments {
        do {
          let contact = try document.data(as: Contact.self)
          print("cont: ", contact.id)
          result.append(contact)
        } catch let error as NSError {
          debugPrint("error: \(error.localizedDescription)")
        }
      }
      self.data = result
      self.gotAnswer = true
    }
  }
  func callfunc(){
    self.gotAnswer = false
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
