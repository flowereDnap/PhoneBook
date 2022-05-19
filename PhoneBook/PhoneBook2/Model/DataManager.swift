//
//  DataLoader.swift
//  PhoneBook2
//
//  Created by User on 07.03.2022.
//

import UIKit
import FirebaseAuth

enum DataProv: String, CaseIterable, Codable{
  case userDefaults
  case file
  case core
  case server
}

class DataManager {
 
  private static var dataProvider: DataProvider = UserDefaultsDataProvider()
  
  
  
  static var dataProvType: DataProv = { () -> DataProv in
      var data2: DataProv?
      if let mydata = UserDefaults.standard.value(forKey:DataManager.dataProvTypeKey) as? Data {
        data2 = try? JSONDecoder().decode(DataProv.self, from: mydata)
      }
    
    switch data2 {
    case .file:
      dataProvider = FileDataProvider()
    case .core:
      dataProvider = CoreDataProvider()
    case .server:
      dataProvider = ApiClient()
    default:
      dataProvider = UserDefaultsDataProvider()
    }
    return data2 ?? DataProv.userDefaults
  }() {
    didSet{
      UserDefaults.standard.set(try? JSONEncoder().encode(dataProvType), forKey:DataManager.dataProvTypeKey)
      
    
      switch dataProvType {
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
  }
  
  static let dataProvTypeKey = "dataProvTypeKey"
  static let contactListKey = "contactsList5"
  static let userKey = "userKey"
  
  
  static var data: [Contact] {
    get {
      return dataProvider.data }
    set {
      dataProvider.data = newValue
    }
  }
  static var contactsView: ViewController!
  
  static func setUpProvider(dataProv: DataProv?) {
    guard let dataProv = dataProv else {
      return
    }
    
    if dataProv == .server {
      
    } else {
      dataProvType = dataProv
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
