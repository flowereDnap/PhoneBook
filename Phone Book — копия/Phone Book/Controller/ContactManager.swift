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
  
  var count: Int {
    return data.count
  }

  func addContact(contact: Contact) {
    data.append(contact)
    save()
  }
  
  func getContact(Id: String) -> Contact {
    return data[ data.firstIndex(where: { (($0.mainFields.first(where: {$0.type == .id})?.value?.value())! as! String) == Id
    })!]
  }
  
  func updContact(Id: String, mainFields: [ContactField]? = nil , additionalFields:[ContactField]?) {
    if let mainFields = mainFields {
      data[ data.firstIndex(where: { (($0.mainFields.first(where: {$0.type == .id})?.value?.value())! as! String) == Id
      })!].mainFields = mainFields
    }
    if let additionalFields = additionalFields {
      data[ data.firstIndex(where: { (($0.mainFields.first(where: {$0.type == .id})?.value?.value())! as! String) == Id
      })!].additionalFields = additionalFields
    }
    save()
  }
  
  func deleteContact(Id: String) {
    
    data.remove(at: data.firstIndex(where: { (($0.mainFields.first(where: {$0.type == .id})?.value?.value())! as! String) == Id
    })!)
    save()
  }
  
  //upd of model
  func save() {
    Model.data = self.data
  }
}



