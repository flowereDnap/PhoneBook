//
//  DataProviderProtocol.swift
//  PhoneBook2
//
//  Created by User on 07.03.2022.
//

import UIKit

protocol DataProvider {
  var data: [Contact] {get set}
  func save()
  func addContact() -> Contact
  func updContact(contact: Contact)
  func deleteContact(id: String)
  
}
