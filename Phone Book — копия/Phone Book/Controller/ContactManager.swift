//
//  Controller.swift
//  Phone Book
//
//  Created by User on 31.10.2021.
//

import Foundation
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
    var data: [Contact] = Model.data{
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
    var currentContactId:Int{
        set(newId){
            Model.currentContactId = newId
        }
        get{
            return Model.currentContactId
        }
    }
    var count:Int{
        return data.count
    }
   
    func addContact(contact:Contact){
        data.append(contact)
        data[count-1].id = Model.id
        save()
    }
    
    func getContact(Id: Int) -> Contact{
        return data[data.firstIndex(where: {$0.id == Id})!]
    }
    
    func updContact(Id:Int , name:String? , number:String?){
        if let name = name{
            data[data.firstIndex(where: {$0.id == Id})!].name = name
        }
        if let number = number {
            data[data.firstIndex(where: {$0.id == Id})!].number = number
        }
        save()
    }
    
    func deleteContact(Id:Int){
        
        data.remove(at: data.firstIndex(where: {$0.id == Id})!)
        save()
    }
    
    //check of input data
    func numberCheck(number:String)->(Bool){
        if CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: String(number.dropFirst(1)))) && (number.first == "+" || number.first?.isNumber ?? true){
            return true
        }
        else{
            return false
        }
    }
    //upd of model
    func save() {
        Model.data = self.data
    }
}



