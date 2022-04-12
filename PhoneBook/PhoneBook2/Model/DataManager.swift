//
//  DataLoader.swift
//  PhoneBook2
//
//  Created by User on 07.03.2022.
//

import UIKit

enum DataProv: String, CaseIterable{
  case userDefaults
  case file
  case core
  case server
}

class DataManager {
  
  private static var dataProvider: DataProvider = UserDefaultsDataProvider()
  
  static let contactListKey = "contactsList5"
  
  static var user: User!
  
  static var data: [Contact] {
    get {
      return dataProvider.data }
    set {
      dataProvider.data = newValue
    }
  }
  static var contactsView: ViewController!
  
  static func setUpProvider(dataProv: DataProv = .file) {
    switch dataProv {
    case .userDefaults:
      dataProvider = UserDefaultsDataProvider()
    case .file:
      dataProvider = FileDataProvider()
    case .core:
      dataProvider = CoreDataProvider()
    case .server:
      dataProvider = ApiClient()
    }
  }
  public static func addContact()->Contact{
    dataProvider.addContact()
  }
  
  public static func updContact(contact: Contact) {
    dataProvider.updContact(contact: contact)
    dataProvider.save()
  }
  
  public static func deleteContact(id: String) {
    dataProvider.deleteContact(id: id)
    data = dataProvider.data
    contactsView.reloadTableViewData(with: "")
  }
  
  public static func save() {
    dataProvider.save()
    contactsView.reloadTableViewData(with: "")
  }
}
