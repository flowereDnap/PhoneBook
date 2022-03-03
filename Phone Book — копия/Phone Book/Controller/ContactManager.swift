import UIKit
import CloudKit

//  FIXME: What does it mean class Controller?
class Weak<T: AnyObject> {
  weak var value : T?
  init (value: T) {
    self.value = value
  }
}



class ContactManager {
  
  private static var model:Model = Model(dataSaveType: .usdefault)
  //MARK: -Model management
  static func getModel() -> Model {
    return ContactManager.model
  }
  func setupModel(dataSaveType: Model.DataSaveType) {
    print("setup called")
    let model = Model(dataSaveType: dataSaveType)
    ContactManager.model = model
    print("model data: ", model.data)
    self.data = model.data
  }
  
  
  //Notifier of contact list changed
  var data: [Contact] = getModel().data {
    willSet{
      print("will set")
    }
    didSet{
      notify()
    }
  }
  
  private lazy var observers = [Observer]()
  
  func attach(_ observer: Observer) {
    observers.append(observer)
  }
  
  func detach(_ observer: Observer) {
    if let idx = observers.firstIndex(where: { $0 === observer }) {
      observers.remove(at: idx)
    }
  }
  
  func notify() {
    observers.forEach({ $0.update(subject: self)})
  }
  
 
  
  var count: Int {
    return data.count
  }
  
 
  //MARK: -Contact managment
  func addContact(contact: Contact) {
    ContactManager.model.dataProvider.addContact(contact: contact)
  }
  
  func getContact(Id: String) -> Contact {
    ContactManager.model.dataProvider.getContact(Id: Id)
  }
  
  func updContact(Id: String, mainFields: [ContactField]? = nil , additionalFields:[ContactField]?) {
    ContactManager.model.dataProvider.updContact(Id: Id, mainFields: mainFields, additionalFields: additionalFields)
  }
  
  func deleteContact(Id: String) {
    ContactManager.model.dataProvider.deleteContact(Id: Id)
  }
  
  //upd of model
  func save() {
    ContactManager.getModel().data = self.data
  }
}



