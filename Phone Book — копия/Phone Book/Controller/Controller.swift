//
//  Controller.swift
//  Phone Book
//
//  Created by User on 31.10.2021.
//

import Foundation
import UIKit

class Controller: UIViewController{
    
    var currentContactId:Int{
        set(newId){
            Model.currentContactId = newId
        }
        get{
            return Model.currentContactId
        }
    }
    var count:Int{
        return Model.data.count
    }
    
    public func AddContact(contact:Contact)->(){
        Model.data.append(contact)
    }
    
    func getContact(Id: Int = currentContactId)->Contact{
        return Model.data[Id]
    }
    func updCurrentContact(contact: Contact){
        Model.data[Model.currentContactId] = contact
    }
    func deleteCurrentContact(){
        Model.data.remove(at: Model.currentContactId)
    }
    
}
