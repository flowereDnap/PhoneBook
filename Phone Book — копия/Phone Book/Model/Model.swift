import UIKit

protocol ContactsDataProtocol {
  var allContacts: [Contact] { get set}
  var id: String {get}
  var count: Int {get}
  //MARK: -Contact managment
  func addContact(contact: Contact)
  func getContact(Id: String) -> Contact
  func updContact(Id: String,
                  mainFields: [ContactField]?,
                  additionalFields:[ContactField]?)
  func deleteContact(Id: String)
  //upd of model
  func save()
}

class Model {
  
  enum DataSaveType{
    case usdefault
    case file
    case core
  }
 
  public var dataProvider: ContactsDataProtocol!

  static let contactListKey = "contactsList3"
  static let idKey = "id"
  public var id: String{
    get{
      return self.dataProvider.id
    }
  }
  public var data: [Contact] {
    get {
      return dataProvider.allContacts
    }
    set {
      dataProvider.allContacts = newValue
    }
  }
  
  init(dataSaveType: DataSaveType) {
    switch dataSaveType {
    case .usdefault:
      self.dataProvider = UserDefaultsDataProvide()
    case .file:
      self.dataProvider = FileDataProvider()
    case .core:
      self.dataProvider = CoreDataProvider()
    }
  }
  
  
}







