import UIKit

//  FIXME: What does it mean class Controller?
class Weak<T: AnyObject> {
  weak var value : T?
  init (value: T) {
    self.value = value
  }
}



class ContactManager {
  
  //Notifier of contact list changed
  var data: [Contact] = Model.data {
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
  
  //Contact manegment
  var currentContactId: Int {
    set(newId){
      Model.currentContactId = newId
    }
    get{
      return Model.currentContactId
    }
  }
  var count: Int {
    return data.count
  }

  func addContact(contact: Contact) {
    data.append(contact)
    save()
  }
  
  func getContact(Id: Int) -> Contact {
    return data[data.firstIndex(where: {$0.id == Id})!]
  }
  
  func updContact(Id: Int, name: String?, number: String?, image: UIImage?, mainFields: [ContactField]? = nil , additionalFields:[ContactField]?) {
    if let name = name {
      data[data.firstIndex(where: {$0.id == Id})!].name = name
    }
    if let number = number {
      data[data.firstIndex(where: {$0.id == Id})!].number = number
    }
    if let image = image {
      data[data.firstIndex(where: {$0.id == Id})!].image = image
    }
    if let mainFields = mainFields {
      data[data.firstIndex(where: {$0.id == Id})!].mainFields = mainFields
    }
    if let additionalFields = additionalFields {
      data[data.firstIndex(where: {$0.id == Id})!].additionalFields = additionalFields
    }
    save()
  }
  
  func deleteContact(Id: Int) {
    
    data.remove(at: data.firstIndex(where: {$0.id == Id})!)
    save()
  }
  
  //upd of model
  func save() {
    Model.data = self.data
  }
}



